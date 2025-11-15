const { Sequelize, DataTypes } = require('sequelize');
const jwt = require('jsonwebtoken');
const express = require('express')

const JWT_SECRET = 'my-secret-key';
const app = express()
const port = 3000

const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: ':memory:', // or './database.sqlite'
});

// database models
const Session = sequelize.define('Session', {
    eventName: { type: DataTypes.STRING, allowNull: false },
    hostToken: { type: DataTypes.STRING, unique: true, allowNull: false },
    isActive: { type: DataTypes.BOOLEAN, defaultValue: true }
});

const Attendance = sequelize.define('Attendance', {
    sessionId: { type: DataTypes.INTEGER, allowNull: false },
    studentId: { type: DataTypes.STRING, allowNull: false },
    studentName: { type: DataTypes.STRING, allowNull: false }
}, {
    indexes: [{ unique: true, fields: ['sessionId', 'studentId'] }]
});

Session.hasMany(Attendance, { foreignKey: 'sessionId', onDelete: 'CASCADE' });
Attendance.belongsTo(Session, { foreignKey: 'sessionId' });


// helper functions
const generateToken = () => Math.random().toString(36).substring(2, 15);

const generateQR = (sessionId) => {
    return jwt.sign({ sessionId, type: 'qr' }, JWT_SECRET, { expiresIn: `${QR_EXPIRY}s` });
};

const verifyQR = (token) => {
    try {
        return jwt.verify(token, JWT_SECRET);
    } catch (error) {
        throw new Error(error.name === 'TokenExpiredError' ? 'QR expired' : 'Invalid QR');
    }
};

// api endpoint

// Create Session
app.post('/api/sessions', async (req, res) => {
    try {
        const { eventName } = req.body;
        const hostToken = generateToken();
        const session = await Session.create({ eventName, hostToken });
        const qrToken = generateQR(session.id);

        res.json({
            sessionId: session.id,
            eventName: session.eventName,
            hostToken,
            qrToken,
            qrTokenExpiry: QR_EXPIRY
        });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Get New QR Token
app.get('/api/sessions/:hostToken/qr', async (req, res) => {
    try {
        const session = await Session.findOne({ where: { hostToken: req.params.hostToken, isActive: true } });
        if (!session) return res.status(404).json({ error: 'Session not found' });

        res.json({ qrToken: generateQR(session.id), expiresIn: QR_EXPIRY });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Get Attendances
app.get('/api/sessions/:hostToken/attendances', async (req, res) => {
    try {
        const session = await Session.findOne({
            where: { hostToken: req.params.hostToken },
            include: [{ model: Attendance, attributes: ['studentId', 'studentName', 'createdAt'] }]
        });

        if (!session) return res.status(404).json({ error: 'Session not found' });

        res.json({
            eventName: session.eventName,
            totalAttendees: session.Attendances.length,
            attendances: session.Attendances
        });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Student Check-in
app.post('/api/check-in', async (req, res) => {
    try {
        const { qrToken, studentId, studentName } = req.body;

        const decoded = verifyQR(qrToken);
        const session = await Session.findByPk(decoded.sessionId);

        if (!session || !session.isActive) {
            return res.status(404).json({ error: 'Session not found or inactive' });
        }

        const attendance = await Attendance.create({
            sessionId: session.id,
            studentId,
            studentName
        });

        res.json({
            message: 'Check-in successful',
            eventName: session.eventName,
            studentName: attendance.studentName
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(409).json({ error: 'Already checked in' });
        }
        res.status(400).json({ error: error.message });
    }
});

sequelize.sync().then(() => {
    app.listen(port, () => {
        console.log(`Backend listening on port ${port}`)
    })
});
