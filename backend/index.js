// index.js
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Mock data for categories
const categories = {
  cashBox: 17873.82,
  categorys: [
    { id: 1, category: 'ค่าอาหาร', amount: 10000.0, color: '#41486D' },
    { id: 2, category: 'ค่าเดินทาง', amount: 2500.0, color: '#FF9595' },
    { id: 3, category: 'ค่าของใช้', amount: 20000.0, color: '#FFB459' }
  ]
};

// Endpoint to get categories
app.get('/api/categories', (req, res) => {
  res.json(categories);
});

// Endpoint to add a new category
app.post('/api/categories', (req, res) => {
  const newCategory = req.body;
  newCategory.id = categories.categorys.length + 1; // Simple ID assignment
  categories.categorys.push(newCategory);
  res.status(201).json(newCategory);
});

// Delete a category by ID
app.delete('/api/categories/:id', (req, res) => {
    const categoryId = parseInt(req.params.id, 10);
    const index = categories.categorys.findIndex(cat => cat.id === categoryId);
  
    if (index !== -1) {
      categories.categorys.splice(index, 1);
      res.status(200).json({ message: 'Category deleted successfully' });
    } else {
      res.status(404).json({ message: 'Category not found' });
    }
  });
  

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
  
