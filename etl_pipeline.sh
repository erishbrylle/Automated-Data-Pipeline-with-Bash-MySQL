#!/bin/bash
# =======================================================
# 📊 Automated Data Pipeline (ETL) with MySQL (Windows-safe)
# Dataset: Healthcare (from Kaggle)
#
# Steps:
#   1. Extract  -> copy raw CSV into working file
#   2. Transform -> clean data (fix spaces, CRLF issues, normalize Name column)
#   3. Load     -> create database/table + load into MySQL
#   4. Verify   -> show row count inserted
# =======================================================

# -------------------------------------------------------
# 🔧 CONFIGURATION
# -------------------------------------------------------
RAW_DATA="raw_data.csv"          # Original Kaggle dataset (must exist in repo)
CLEAN_DATA="clean_data.csv"      # Cleaned output file
DB_NAME="etl_demo"               # Database name
TABLE_NAME="healthcare"          # Table name
MYSQL_USER="root"                # MySQL user
MYSQL_PASS="pokemon12"           # MySQL password
LOG_FILE="etl_log.txt"           # Log file for MySQL output/errors
WIN_ETL_DIR="/c/etl"             # Git Bash path for C:\etl
WIN_FILE="C:/etl/clean_data.csv" # Windows-style path for LOAD DATA

# -------------------------------------------------------
# ✅ Step 0: Pre-flight checks
# -------------------------------------------------------
echo
echo "🔎 Pre-flight checks..."
if [ ! -f "$RAW_DATA" ]; then
  echo "❌ Error: $RAW_DATA not found in $(pwd). Put your CSV here and re-run."
  exit 1
fi

if ! command -v mysql >/dev/null 2>&1; then
  echo "❌ Error: 'mysql' client not found in PATH."
  exit 1
fi

# -------------------------------------------------------
# 📥 STEP 1: EXTRACT
# -------------------------------------------------------
echo
echo "📥 Extracting data..."
cp "$RAW_DATA" temp_data.csv

# -------------------------------------------------------
# 🛠 STEP 2: TRANSFORM
# - keep header + rows with exactly 15 fields
# - trim spaces from each field
# - normalize Name column (capitalize given/surname)
# - remove CRLF endings
# -------------------------------------------------------
echo "🛠 Transforming data..."
awk -F, 'NR==1 {
    # --- HEADER ---
    print
    next
}
NF==15 {
    # Trim spaces from all fields
    for(i=1;i<=NF;i++){ gsub(/^ +| +$/,"",$i) }

    # Normalize Name (field 1)
    split($1, parts, " ")
    for(j in parts){
        parts[j] = tolower(parts[j])
        parts[j] = toupper(substr(parts[j],1,1)) substr(parts[j],2)
    }
    $1 = parts[1]
    for(j=2; j in parts; j++){
        $1 = $1 " " parts[j]
    }

    # Remove commas from Hospital column (field 9)
    gsub(/,/, "", $9)

    # Rebuild row explicitly with commas so commas never disappear
    OFS=","; print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15
}' temp_data.csv > "$CLEAN_DATA"

# -------------------------------------------------------
# 🧭 STEP 2.5: Prepare Windows-safe path
# -------------------------------------------------------
echo "📂 Preparing Windows-safe location: $WIN_ETL_DIR"
mkdir -p "$WIN_ETL_DIR"
cp "$CLEAN_DATA" "$WIN_ETL_DIR/clean_data.csv"
echo "✅ Clean file copied to: $WIN_FILE"

# -------------------------------------------------------
# 💾 STEP 3: LOAD INTO MYSQL
# -------------------------------------------------------
echo
echo "💾 Loading into MySQL (logging to $LOG_FILE)..."

mysql --local-infile=1 -u"$MYSQL_USER" -p"$MYSQL_PASS" <<EOF 2>&1 | tee "$LOG_FILE"
SET GLOBAL local_infile = 1;

CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Gender VARCHAR(20),
    Blood_Type VARCHAR(10),
    Medical_Condition VARCHAR(255),
    Date_of_Admission DATE,
    Doctor VARCHAR(255),
    Hospital VARCHAR(255),
    Insurance_Provider VARCHAR(255),
    Billing_Amount DECIMAL(14,2),
    Room_Number INT,
    Admission_Type VARCHAR(100),
    Discharge_Date DATE,
    Medication VARCHAR(255),
    Test_Results VARCHAR(255)
);

LOAD DATA LOCAL INFILE '$WIN_FILE'
INTO TABLE $TABLE_NAME
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Name, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor, Hospital, Insurance_Provider, Billing_Amount, Room_Number, Admission_Type, Discharge_Date, Medication, Test_Results);

SELECT COUNT(*) AS '✅ Rows Inserted' FROM $TABLE_NAME;
EOF

# -------------------------------------------------------
# 🧹 CLEANUP & FINAL MESSAGE
# -------------------------------------------------------
rm temp_data.csv 2>/dev/null || true
echo
echo "📜 MySQL output also saved to $LOG_FILE."
read -p "Press Enter to exit..."
