const { Sequelize, DataTypes } = require('sequelize');
const express = require('express')
const app = express()
const port = 3000

const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: ':memory:',
});

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.listen(port, () => {
    console.log(`Backend listening on port ${port}`)
})
