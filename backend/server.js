const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const {
  JsonRpcProvider,
  Interface,
  parseUnits,
  formatUnits,
  getAddress,
} = require('ethers');

const app = express();

app.use(cors());
app.use(express.json());

// ==========================
// BSC SETTINGS
// ==========================

const PORT = 3000;

const RPC_URL = 'https://bsc-dataseed.bnbchain.org';

const BSC_CHAIN_ID = 56n;

// USDT BSC contract
const USDT_CONTRACT = getAddress(
  '0x55d398326f99059fF775485246999027B3197955'
);

// Your Binance BSC deposit address
const DEPOSIT_ADDRESS = getAddress(
  '0x51cc4b4407d8ad80450e6a66adebd58941824f64'
);

// VIP price
const REQUIRED_AMOUNT = '10';

// USDT on BSC uses 18 decimals
const USDT_DECIMALS = 18;

// Number of confirmations required
const MIN_CONFIRMATIONS = 3;

const provider = new JsonRpcProvider(RPC_URL);

// ==========================
// PREVENT TXID REUSE
// ==========================

const usedTxFile = path.join(__dirname, 'used-tx.json');

let usedTxIds = new Set();

if (fs.existsSync(usedTxFile)) {
  try {
    const saved = JSON.parse(
      fs.readFileSync(usedTxFile, 'utf8')
    );

    usedTxIds = new Set(saved);
  } catch (error) {
    console.log('Could not load used-tx.json');
  }
}

function saveUsedTxIds() {
  fs.writeFileSync(
    usedTxFile,
    JSON.stringify([...usedTxIds], null, 2)
  );
}

// ==========================
// USDT TRANSFER EVENT
// ==========================

const usdtInterface = new Interface([
  'event Transfer(address indexed from, address indexed to, uint256 value)',
]);

// ==========================
// HEALTH CHECK
// ==========================

app.get('/health', async (req, res) => {
  try {
    const network = await provider.getNetwork();

    res.json({
      ok: true,
      chainId: network.chainId.toString(),
      message: 'Payment backend is running',
    });
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Cannot connect to BSC',
    });
  }
});

// ==========================
// VERIFY PAYMENT
// ==========================

app.post('/verify-payment', async (req, res) => {
console.log('VERIFY REQUEST:', req.body);
  const txid = String(req.body?.txid || '').trim();

  // Check TxID format
  if (!/^0x[a-fA-F0-9]{64}$/.test(txid)) {
    return res.status(400).json({
      ok: false,
      message: 'Invalid TxID format',
    });
  }

  const normalizedTxid = txid.toLowerCase();

  // Prevent using same payment twice
  if (usedTxIds.has(normalizedTxid)) {
    return res.status(409).json({
      ok: false,
      message: 'This transaction has already been used',
    });
  }

  try {
    // Verify network
    const network = await provider.getNetwork();

    if (network.chainId !== BSC_CHAIN_ID) {
      return res.status(500).json({
        ok: false,
        message: 'Wrong blockchain network',
      });
    }

    // Get transaction receipt
    const receipt =
      await provider.getTransactionReceipt(txid);

    if (!receipt) {
      return res.status(404).json({
        ok: false,
        status: 'pending',
        message:
          'Transaction not found or still pending',
      });
    }

    // Transaction failed on-chain
    if (receipt.status !== 1) {
      return res.status(400).json({
        ok: false,
        message: 'Transaction failed',
      });
    }

    // Confirmations
    const currentBlock =
      await provider.getBlockNumber();

    const confirmations =
      currentBlock - receipt.blockNumber + 1;

    if (confirmations < MIN_CONFIRMATIONS) {
      return res.status(202).json({
        ok: false,
        status: 'pending',
        confirmations,
        message: 'Waiting for confirmations',
      });
    }

    // ==========================
    // FIND USDT SENT TO WALLET
    // ==========================

    let totalReceived = 0n;

    for (const log of receipt.logs) {
      let logAddress;

      try {
        logAddress = getAddress(log.address);
      } catch {
        continue;
      }

      // Must be the real USDT contract
      if (logAddress !== USDT_CONTRACT) {
        continue;
      }

      let parsed;

      try {
        parsed = usdtInterface.parseLog(log);
      } catch {
        continue;
      }

      if (!parsed || parsed.name !== 'Transfer') {
        continue;
      }

      const recipient =
        getAddress(parsed.args.to);

      // Must arrive at your wallet
      if (recipient !== DEPOSIT_ADDRESS) {
        continue;
      }

      totalReceived += parsed.args.value;
    }

    // Required 10 USDT
    const requiredAmount = parseUnits(
      REQUIRED_AMOUNT,
      USDT_DECIMALS
    );

    if (totalReceived < requiredAmount) {
      return res.status(400).json({
        ok: false,
        message: 'Insufficient USDT amount',
        received: formatUnits(
          totalReceived,
          USDT_DECIMALS
        ),
        required: REQUIRED_AMOUNT,
      });
    }

    // Mark transaction as used
    usedTxIds.add(normalizedTxid);
    saveUsedTxIds();

    // Payment verified
    const vipUntil = new Date(
      Date.now() + 60 * 60 * 1000
    ).toISOString();
    return res.json({
      ok: true,
      status: 'paid',
      message: 'Payment verified successfully',
      vipUntil,
      txid,
      received: formatUnits(
        totalReceived,
        USDT_DECIMALS
      ),
      required: REQUIRED_AMOUNT,
      confirmations,
    });

  } catch (error) {
    console.error(error);

    return res.status(500).json({
      ok: false,
      message: 'Payment verification error',
    });
  }
});

// ==========================
// START SERVER
// ==========================
// ================================
// AUTOMATIC PAYMENT SESSIONS
// ================================

const paymentSessions = new Map();

app.post('/create-payment', async (req, res) => {
  try {
    const paymentId =
      Date.now().toString() +
      Math.random().toString(36).substring(2, 10);
let uniqueAmount;
    let alreadyUsed;

    do {
      const uniquePart =
        Math.floor(Math.random() * 99) + 1;

      uniqueAmount =
        (10 + uniquePart / 10000).toFixed(4);

      alreadyUsed = [...paymentSessions.values()].some(
        (session) =>
          session.status === 'waiting' &&
          session.amount === uniqueAmount
      );
    } while (alreadyUsed);

    const startBlock = await provider.getBlockNumber();

    paymentSessions.set(paymentId, {
      paymentId,
      amount: uniqueAmount,
      address: DEPOSIT_ADDRESS,
      startBlock,
      status: 'waiting',
      createdAt: Date.now(),
      txid: null,
      vipUntil: null,
    });

    return res.json({
      ok: true,
      paymentId,
      amount: uniqueAmount,
      address: DEPOSIT_ADDRESS,
      network: 'BSC',
      status: 'waiting',
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      ok: false,
      message: 'Could not create payment session',
    });
  }
});
// ================================
// PAYMENT STATUS
// ================================

app.get('/payment-status/:paymentId', async (req, res) => {
  const { paymentId } = req.params;

  const session = paymentSessions.get(paymentId);

  if (!session) {
    return res.status(404).json({
      ok: false,
      message: 'Payment session not found',
    });
  }

  return res.json({
    ok: true,
    paymentId: session.paymentId,
    status: session.status,
    amount: session.amount,
    address: session.address,
    txid: session.txid,
    vipUntil: session.vipUntil,
  });
});
// ======================================
// AUTOMATIC USDT PAYMENT MONITOR
// ======================================

let paymentCheckRunning = false;

async function checkAutomaticPayments() {
  if (paymentCheckRunning) return;
  paymentCheckRunning = true;

  try {
    const currentBlock = await provider.getBlockNumber();

    for (const session of paymentSessions.values()) {
      if (session.status !== 'waiting') continue;

      const filter = {
        address: USDT_CONTRACT,
        fromBlock: session.startBlock,
        toBlock: currentBlock,
        topics: [
          id('Transfer(address,address,uint256)'),
          null,
          zeroPadValue(DEPOSIT_ADDRESS, 32),
        ],
      };

      const logs = await provider.getLogs(filter);

      for (const log of logs) {
        if (usedTxIds.has(log.transactionHash.toLowerCase())) {
          continue;
        }

        const parsed = usdtInterface.parseLog(log);

        if (!parsed) continue;

        const amount = formatUnits(
          parsed.args.value,
          USDT_DECIMALS
        );

        if (amount !== session.amount) continue;

        const confirmations =
          currentBlock - log.blockNumber + 1;

        if (confirmations < MIN_CONFIRMATIONS) {
          continue;
        }

        session.status = 'paid';
        session.txid = log.transactionHash;
        session.vipUntil = new Date(
          Date.now() + 60 * 60 * 1000
        ).toISOString();

        usedTxIds.add(
          log.transactionHash.toLowerCase()
        );

        saveUsedTxIds();

        console.log(
          'Automatic payment verified:',
          session.paymentId,
          session.amount,
          session.txid
        );

        break;
      }
    }
  } catch (error) {
    console.error(
      'Automatic payment check error:',
      error
    );
  } finally {
    paymentCheckRunning = false;
  }
}

setInterval(checkAutomaticPayments, 5000);
const server = app.listen(PORT, () => {
  console.log('Payment backend running on http://localhost:' + PORT);
});

process.stdin.resume();