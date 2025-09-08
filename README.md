# 📊 Automated Data Pipeline with Bash + MySQL

This project demonstrates a simple ETL (Extract, Transform, Load) pipeline using Bash scripting and MySQL.
It loads a healthcare dataset (from Kaggle

---

## 📂 Project Structure
```bash
.
├── raw_data.csv        # Original Kaggle dataset (input)
├── clean_data.csv      # Cleaned dataset (generated)
├── etl_pipeline.sh     # Main ETL script
├── etl_log.txt         # Log file with MySQL output/errors
└── README.md           # Project documentation
```

---

## ⚙️ Prerequisites

- MySQL Server (8.0+ recommended)
- Git Bash or any Bash shell (Windows-safe tested)
- User credentials:
- Username: root
- Password: pokemon12
  
You can edit these inside the script:

```bash
MYSQL_USER="root"
MYSQL_PASS="pokemon12"
```

---

## ▶️ How to Run:
1. Clone the repo and navigate inside:
```bash
git clone <your-repo-url>
cd <repo-folder>
```
2. Clone the repo and navigate inside:
```bash
raw_data.csv
```
3. Run the ETL pipeline script:
```bash
bash etl_pipeline.sh
```
4. When finished, the cleaned file will also be copied to:
```bash
C:/etl/clean_data.csv
```

---
 
## 🗄️ Database & Table
- Database: etl_demo
- Table: healthcare
  
| Column              | Type          | Description            |
| ------------------- | ------------- | ---------------------- |
| id                  | INT AUTO PK   | Auto-increment ID      |
| Name                | VARCHAR(255)  | Patient name (cleaned) |
| Age                 | INT           | Age                    |
| Gender              | VARCHAR(20)   | Gender                 |
| Blood\_Type         | VARCHAR(10)   | Blood group            |
| Medical\_Condition  | VARCHAR(255)  | Medical diagnosis      |
| Date\_of\_Admission | DATE          | Admission date         |
| Doctor              | VARCHAR(255)  | Attending doctor       |
| Hospital            | VARCHAR(255)  | Hospital name          |
| Insurance\_Provider | VARCHAR(255)  | Insurance details      |
| Billing\_Amount     | DECIMAL(14,2) | Billing cost           |
| Room\_Number        | INT           | Room assignment        |
| Admission\_Type     | VARCHAR(100)  | Type (Urgent, etc.)    |
| Discharge\_Date     | DATE          | Discharge date         |
| Medication          | VARCHAR(255)  | Prescribed meds        |
| Test\_Results       | VARCHAR(255)  | Diagnostic results     |


---

## 🧑‍💻 Author

This project was created as a sample portfolio project to showcase Bash scripting + ETL pipeline skills.

