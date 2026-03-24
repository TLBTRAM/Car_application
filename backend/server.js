const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mysql = require('mysql2/promise');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// MySQL Connection Pool
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root', // Thay đổi nếu cần
    password: '123456',     // Thay đổi nếu cần
    database: 'car_booking_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// API: Đăng nhập
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const [rows] = await pool.execute(
            'SELECT * FROM users WHERE email = ? AND password = ?',
            [email, password]
        );
        
        if (rows.length > 0) {
            const user = rows[0];
            res.json({ 
                success: true, 
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    role: user.role,
                    rides: user.rides,
                    spent: user.spent
                },
                token: `dummy-jwt-token-${user.id}`
            });
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Đăng ký
app.post('/api/register', async (req, res) => {
    const { name, email, password, role } = req.body;
    try {
        // Kiểm tra tồn tại
        const [existing] = await pool.execute('SELECT email FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(400).json({ success: false, message: 'User already exists' });
        }

        const id = `u${Date.now()}`;
        const userRole = role || 'customer';
        
        await pool.execute(
            'INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)',
            [id, name, email, password, userRole]
        );

        res.json({ 
            success: true, 
            user: { id, name, email, role: userRole } 
        });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Lấy danh sách xe
app.get('/api/cars', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM cars');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Lưu chuyến xe mới
app.post('/api/bookings', async (req, res) => {
    const { customer_id, pickup, destination, car_id, car_name, total_price, distance } = req.body;
    const id = `b${Date.now()}`;

    try {
        await pool.execute(
            'INSERT INTO bookings (id, customer_id, pickup, destination, car_id, car_name, total_price, distance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [id, customer_id, pickup, destination, car_id, car_name, total_price, distance]
        );
        res.json({ success: true, id });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Lấy lịch sử chuyến xe (Customer)
app.get('/api/bookings/user/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const [rows] = await pool.execute(
            'SELECT * FROM bookings WHERE customer_id = ? ORDER BY created_at DESC', 
            [userId]
        );
        res.json(rows);
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Lấy danh sách chuyến xe (Driver)
app.get('/api/driver/rides', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM bookings WHERE status != "completed" ORDER BY created_at DESC');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Cập nhật trạng thái chuyến xe
app.put('/api/bookings/:id/status', async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;
    try {
        await pool.execute('UPDATE bookings SET status = ? WHERE id = ?', [status, id]);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Admin - Lấy toàn bộ user
app.get('/api/admin/users', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT id, name, email, role, rides, spent FROM users ORDER BY created_at DESC');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Admin - Thêm user
app.post('/api/admin/users', async (req, res) => {
    const { name, email, password, role } = req.body;
    const id = `u${Date.now()}`;
    try {
        await pool.execute(
            'INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)',
            [id, name, email, password || '123', role || 'customer']
        );
        res.json({ success: true, id });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Admin - Cập nhật user
app.put('/api/admin/users/:id', async (req, res) => {
    const { id } = req.params;
    const { name, email, role } = req.body;
    try {
        await pool.execute(
            'UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?',
            [name, email, role, id]
        );
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// API: Admin - Xóa user
app.delete('/api/admin/users/:id', async (req, res) => {
    const { id } = req.params;
    try {
        // Xóa các booking liên quan trước (nếu có FK constraint)
        await pool.execute('DELETE FROM bookings WHERE customer_id = ?', [id]);
        await pool.execute('DELETE FROM users WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

app.listen(port, () => {
    console.log(`Backend server running at http://localhost:${port}`);
});
