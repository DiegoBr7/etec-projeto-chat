require("dotenv").config();
const express = require("express");
const http = require("http");
const cors = require("cors");
const jwt = require("jsonwebtoken");
const socketio = require("socket.io");
const pool = require("./db");

const app = express();
const server = http.createServer(app);
const io = socketio(server, { cors: { origin: "*" } });

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Servidor rodando! 🚀 Use /auth, /contacts, etc.");
});


const JWT_SECRET = process.env.JWT_SECRET || "segredo123";

// 🔐 Middleware para proteger rotas
function auth(req, res, next) {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.sendStatus(401);

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}


const bcrypt = require("bcrypt");

// Cadastro
app.post("/auth/register", async (req, res) => {
  try {
    const { username, password, displayName } = req.body;
    const hash = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      "INSERT INTO users (username, password, displayName) VALUES (?, ?, ?)",
      [username, hash, displayName]
    );

    const token = jwt.sign({ id: result.insertId, username }, JWT_SECRET);
    res.json({ token });

  } catch (err) {
    console.error("Erro no cadastro:", err);
    res.status(500).json({ error: err.message });
  }
});

// Login
app.post("/auth/login", async (req, res) => {
  const { username, password } = req.body;

  const [rows] = await pool.query("SELECT * FROM users WHERE username = ?", [username]);
  if (rows.length === 0) return res.status(400).send("Usuário não encontrado");

  const user = rows[0];
  const match = await bcrypt.compare(password, user.password);
  if (!match) return res.status(400).send("Senha inválida");

  const token = jwt.sign({ id: user.id, username }, JWT_SECRET);
  res.json({ token });
});


// Lista de contatos
app.get("/contacts", auth, async (req, res) => {
  const [rows] = await pool.query("SELECT id, username, displayName FROM users WHERE id != ?", [req.user.id]);
  res.json(rows);
});

// Dados do usuário logado
app.get("/users/me", auth, async (req, res) => {
  const [rows] = await pool.query("SELECT id, username, displayName FROM users WHERE id = ?", [req.user.id]);
  res.json(rows[0]);
});

// Enviar mensagem
app.post("/messages", auth, async (req, res) => {
  const { recipientId, content } = req.body;

  const [result] = await pool.query(
    "INSERT INTO messages (senderId, recipientId, content, sentAt) VALUES (?, ?, ?, NOW())",
    [req.user.id, recipientId, content]
  );

  const message = {
    id: result.insertId,
    senderId: req.user.id,
    recipientId,
    content,
    sentAt: new Date()
  };

  // Notifica via WebSocket
  io.to(`user_${recipientId}`).emit("message", message);

  res.json(message);
});


io.on("connection", (socket) => {
  console.log("Novo cliente conectado");

  socket.on("join", (userId) => {
    socket.join(`user_${userId}`);
    console.log(`Usuário ${userId} entrou na sala`);
  });

  socket.on("disconnect", () => {
    console.log("Cliente desconectado");
  });
});



server.listen(3000, () => {
  console.log("Servidor rodando em http://localhost:3000");
});
