The **HAVING clause** in SQL is used to filter grouped data after applying the **GROUP BY** clause. It is similar to the **WHERE clause**, but **HAVING** works on aggregate functions (like `SUM`, `AVG`, `COUNT`, etc.), whereas **WHERE** filters individual rows before aggregation.

---

### **When to Use HAVING**
1. Use **WHERE** to filter rows **before grouping**.
2. Use **HAVING** to filter aggregated/grouped data **after grouping**.

---

### **Syntax**
```sql
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1
HAVING aggregate_function(column2) condition;
```

---

### **Example Tables**
#### **Orders Table**
| OrderID | CustomerID | TotalAmount |
|---------|------------|-------------|
| 1       | 101        | 500         |
| 2       | 102        | 200         |
| 3       | 101        | 300         |
| 4       | 103        | 700         |
| 5       | 102        | 100         |

---

### **Example Queries**

#### **1. Filtering Total Sales Using HAVING**
Get customers whose total sales exceed 500.

**Query:**
```sql
SELECT CustomerID, SUM(TotalAmount) AS TotalSales
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 500;
```

**Result:**
| CustomerID | TotalSales |
|------------|------------|
| 101        | 800        |
| 103        | 700        |

---

#### **2. Using WHERE vs HAVING**
**Problem:** Find customers whose total sales exceed 500 and individual order amounts are greater than 150.

- **Using WHERE**: Filters rows before grouping.
```sql
SELECT CustomerID, SUM(TotalAmount) AS TotalSales
FROM Orders
WHERE TotalAmount > 150
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 500;
```

**Result:**
| CustomerID | TotalSales |
|------------|------------|
| 101        | 800        |
| 103        | 700        |

---

### **Differences Between WHERE and HAVING**

| **Feature**       | **WHERE Clause**                       | **HAVING Clause**                           |
|--------------------|----------------------------------------|---------------------------------------------|
| **Filter Type**    | Filters rows before grouping.          | Filters aggregated data after grouping.     |
| **Use With**       | Columns and simple conditions.         | Aggregate functions like `SUM`, `AVG`, etc. |
| **Execution Order**| Applied before `GROUP BY`.             | Applied after `GROUP BY`.                   |

---

#### Example to Clarify:

1. **WHERE filters rows**: Individual orders with `TotalAmount > 150`.
2. **GROUP BY groups rows**: By `CustomerID`.
3. **HAVING filters groups**: Groups with `SUM(TotalAmount) > 500`.

