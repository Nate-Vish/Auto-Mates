# Data Science & ML Fundamentals
**When to use:** Read when building data features, integrating ML APIs, working with data formats, or collaborating with data teams.

---

## Python Data Stack

| Library | Purpose | When to Use |
|---------|---------|-------------|
| **pandas** | Data manipulation | Reading/cleaning/transforming structured data (CSV, JSON, Excel, SQL) |
| **numpy** | Numerical computing | Array math, vectorized operations |
| **matplotlib** | Static plotting | Basic charts, full control over every element |
| **seaborn** | Statistical visualization | Quick statistical plots on top of matplotlib |
| **Plotly** | Interactive charts | Dashboards, web-embedded charts |
| **scikit-learn** | Machine learning | Classification, regression, clustering, evaluation |
| **Polars** | High-performance DataFrames | Datasets too large/slow for pandas (10GB+) |

```bash
pip install pandas numpy matplotlib seaborn scikit-learn plotly jupyter
```

---

## pandas Essentials

### Reading Data
```python
import pandas as pd
df = pd.read_csv("data.csv")
df = pd.read_json("data.json")
df = pd.read_excel("data.xlsx", sheet_name=0)
df = pd.read_parquet("data.parquet")           # Fastest for analytics
df = pd.read_sql("SELECT * FROM users", conn)
```

### Inspecting Data
```python
df.head()              # First 5 rows
df.info()              # Column types, non-null counts, memory
df.describe()          # Statistical summary
df.shape               # (rows, columns)
df.isnull().sum()      # Missing values per column
```

### Filtering and Selecting
```python
df["name"]                                        # Single column
df[["name", "age"]]                              # Multiple columns
df[df["age"] > 30]                               # Boolean filter
df.query("age > 30 and city == 'NYC'")          # Cleaner syntax
```

### GroupBy and Aggregation
```python
df.groupby("department")["salary"].mean()
df.groupby("department").agg({"salary": "mean", "age": "median"})
df["status"].value_counts()
```

### Common Operations
```python
df["full_name"] = df["first"] + " " + df["last"]
df["age_group"] = df["age"].apply(lambda x: "senior" if x > 65 else "other")
df.fillna(0)
df.dropna(subset=["email"])
df.sort_values("created_at", ascending=False)
df.drop_duplicates(subset=["email"])
df["price"] = df["price"].astype(float)
df["date"] = pd.to_datetime(df["date"])
```

### Merge and Join
```python
merged = pd.merge(orders, customers, on="customer_id", how="left")
combined = pd.concat([df1, df2], ignore_index=True)
```

**Tips:** Use vectorized operations — never loop over rows. Convert low-cardinality string columns to `category` dtype.

---

## numpy Basics

```python
import numpy as np

a = np.array([1, 2, 3, 4, 5])
zeros = np.zeros((3, 4))
rng = np.arange(0, 10, 2)         # [0, 2, 4, 6, 8]

# Vectorized operations — 100x faster than Python loops
result = a * 2
dot = np.dot(a, a)

np.mean(a); np.std(a); np.max(a); np.sum(a)
np.where(a > 3, "high", "low")    # Conditional selection
```

---

## Data Visualization

### matplotlib — Full Control
```python
import matplotlib.pyplot as plt
plt.figure(figsize=(10, 6))
plt.plot(x, y, label="Revenue")
plt.xlabel("Month"); plt.ylabel("Revenue ($)")
plt.title("Monthly Revenue"); plt.legend()
plt.savefig("chart.png", dpi=150)
```

### seaborn — Statistical Plots
```python
import seaborn as sns
sns.histplot(df["age"], bins=20)
sns.boxplot(x="dept", y="salary", data=df)
sns.heatmap(df.corr(), annot=True)
```

### Plotly — Interactive (Web-Ready)
```python
import plotly.express as px
fig = px.line(df, x="date", y="revenue", color="product")
fig.write_html("chart.html")    # Embeddable in web apps
```

**Rule:** matplotlib for full control. seaborn for quick exploration. Plotly for user-facing dashboards.

---

## Statistics Every Developer Needs

| Concept | What It Means | Why You Care |
|---------|---------------|--------------|
| **Mean** | Average value | Sensitive to outliers |
| **Median** | Middle value when sorted | Better than mean with outliers (income, latency) |
| **Std Dev** | How spread out values are | High = widely spread |
| **Percentile** | Value below which X% falls | P95 = "95% of requests are faster than this" |
| **Correlation** | How two variables move together | +1 together, -1 opposite, 0 = no relationship |

```python
df["salary"].mean()
df["salary"].median()
df["salary"].quantile(0.95)   # P95
df[["age", "salary"]].corr()  # Correlation matrix
```

**Important:** Correlation is NOT causation.

---

## ML Concepts

### Supervised vs. Unsupervised
| Type | Input | Goal | Examples |
|------|-------|------|----------|
| **Supervised** | Labeled data (X, y) | Predict y from X | Spam detection, price prediction |
| **Unsupervised** | Unlabeled data (X) | Find structure | Customer segmentation, anomaly detection |

### Classification vs. Regression
- **Classification:** Predict a category. "Is this email spam?" → discrete label
- **Regression:** Predict a number. "What will this house sell for?" → continuous value

### Train / Test / Validation
- **Training (~65%):** Model learns from this
- **Validation (~15%):** Tune hyperparameters
- **Test (~20%):** Final evaluation — never used during training
- **Golden rule:** Never evaluate on training data

### Overfitting vs. Underfitting
- **Overfitting:** Memorizes training data, fails on new data. Train = 99%, test = 60%. Fix: more data, simpler model, regularization
- **Underfitting:** Too simple. Poor on both. Fix: more features, more complex model

---

## Common ML Models (Awareness Level)

| Model | Type | Use When |
|-------|------|----------|
| **Linear Regression** | Regression | Continuous values with linear relationships |
| **Logistic Regression** | Classification | Binary classification (spam/not-spam) |
| **Random Forest** | Both | General-purpose, handles messy data |
| **K-Means** | Unsupervised | Customer segmentation |
| **Neural Networks** | Both | Images, text, complex non-linear patterns |

You do not need to implement these from scratch. Use scikit-learn or cloud APIs.

---

## scikit-learn: The Fit/Predict Pattern

Every scikit-learn model follows the same API:

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

# 1. Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 2. Create model
model = RandomForestClassifier(n_estimators=100)

# 3. Train
model.fit(X_train, y_train)

# 4. Predict
predictions = model.predict(X_test)

# 5. Evaluate
print(accuracy_score(y_test, predictions))
print(classification_report(y_test, predictions))
```

### Evaluation Metrics
| Metric | Use When |
|--------|----------|
| **Accuracy** | Balanced classes only |
| **Precision** | False positives are costly (spam filter) |
| **Recall** | False negatives are costly (disease detection) |
| **F1 Score** | Balance precision and recall |

---

## ML APIs (Preferred Over Training Custom Models)

### OpenAI API
```python
from openai import OpenAI
client = OpenAI()  # Uses OPENAI_API_KEY env var
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Summarize this: ..."}
    ]
)
print(response.choices[0].message.content)
```

### Hugging Face (Local Models)
```python
from transformers import pipeline
classifier = pipeline("sentiment-analysis")
result = classifier("I love this product!")
# [{'label': 'POSITIVE', 'score': 0.9998}]

summarizer = pipeline("summarization")
summary = summarizer(long_text, max_length=100)
```

### Prompt Engineering Basics
- Be specific: "Extract customer name and order ID" > "Parse this email"
- Provide examples: 1-2 examples of desired input/output (few-shot)
- Set constraints: "Respond in JSON with keys: name, email, sentiment"
- Use system messages to define behavior and output format

---

## Data Formats

| Format | Size | Speed | Best For |
|--------|------|-------|----------|
| **CSV** | Large | Moderate | Small data, sharing, human-readable |
| **JSON** | Largest | Slowest | APIs, nested/semi-structured data |
| **Parquet** | Smallest (2-10x compression) | Fastest | Analytics, data pipelines, 100MB+ |

**Rules:** Under 100MB sharing with non-technical? CSV. APIs/nested? JSON. Analytics/pipelines? Parquet.

---

## ETL Basics

ETL = Extract, Transform, Load. Standard pattern for moving data between systems.

```python
import pandas as pd
from sqlalchemy import create_engine

# EXTRACT
raw_orders = pd.read_csv("orders_export.csv")
raw_customers = pd.read_json("https://api.example.com/customers")

# TRANSFORM
orders = raw_orders.dropna(subset=["order_id"])
orders["total"] = orders["total"].astype(float)
orders["order_date"] = pd.to_datetime(orders["order_date"])
merged = pd.merge(orders, raw_customers, on="customer_id", how="left")

# LOAD
engine = create_engine("sqlite:///warehouse.db")
merged.to_sql("order_facts", engine, if_exists="replace", index=False)
```

**ETL vs. ELT:** ETL transforms before loading (traditional). ELT loads raw first, transforms inside the warehouse (modern cloud approach: Snowflake, BigQuery).

---

## ML vs. Rules Decision Guide

| Factor | Use Rules | Use ML |
|--------|-----------|--------|
| Data | Little or none | Abundant historical data |
| Logic | Rules are clear | Patterns are complex/subtle |
| Explainability | Auditable required | Black box acceptable |
| Examples | Tax calc, routing, compliance | Recommendations, fraud, image classification |

**Decision shortcut:** Can you write it in a reasonable number of if/else statements? Use rules. Too many variables, or patterns you can't articulate? Use ML. Best practice: start with rules, add ML when rules become unmanageable.

---

## Jupyter Notebooks

**Use for:** Exploration, prototyping, visualizations, sharing analysis.
**Do NOT use for:** Production code, anything that needs diffs, CI/CD, or automated testing.

**Workflow:** Explore in notebooks → extract proven logic into `.py` modules.

---

## Daily Rules

1. Never loop over DataFrame rows — use vectorized operations
2. Use median over mean when outliers exist; use P95/P99 for latency
3. Every scikit-learn model uses the same fit/predict pattern
4. Start with ML APIs (OpenAI, Hugging Face) before training custom models
5. CSV for small/shared. JSON for APIs. Parquet for analytics/pipelines
6. Explore in notebooks, ship in modules
7. Default to rules-based logic — only add ML when rules can't capture the complexity
8. Always train/test split — never evaluate on training data
9. Correlation is not causation
