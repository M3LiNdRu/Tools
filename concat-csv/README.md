# CSV Concatenation Tool

A Python utility for merging multiple CSV files from a folder into a single consolidated CSV file. Perfect for combining data from similar sources or batch processing CSV files.

## Overview

The **CSV Concatenation Tool** helps you:

- Combine multiple CSV files into one
- Process all CSV files in a folder automatically
- Preserve data integrity and column structure
- Generate a consolidated output file
- Handle large datasets efficiently

This tool is useful for data analysis, data migration, log consolidation, reporting, and any workflow that requires combining multiple CSV files.

## Prerequisites

- **Python** 3.6 or higher
- **pandas** library
- **pip** (Python package manager)

## Installation

### Step 1: Install Python

Download and install Python from [python.org](https://www.python.org/downloads/).

Verify installation:
```bash
python --version
```

### Step 2: Install Required Libraries

Install pandas using pip:

```bash
pip install pandas
```

Verify the installation:
```bash
python -c "import pandas; print(pandas.__version__)"
```

## Project Structure

```
concat-csv/
├── main.py              # Main script
├── input-csv/           # Folder for input CSV files
├── output.csv           # Generated concatenated output
└── README.md            # This file
```

## Configuration

### Input Folder

Place all CSV files you want to concatenate in the `input-csv` folder:

```
concat-csv/
└── input-csv/
    ├── file1.csv
    ├── file2.csv
    ├── file3.csv
    └── ...
```

**Important:** All CSV files should have the same column structure (headers and column order) for best results.

## Usage

### Step 1: Prepare Your CSV Files

1. Create or place your CSV files in the `input-csv` folder
2. Ensure all files have compatible column structures:
   ```
   Example files:
   - sales_2024_q1.csv (ID, Name, Amount, Date)
   - sales_2024_q2.csv (ID, Name, Amount, Date)
   - sales_2024_q3.csv (ID, Name, Amount, Date)
   ```

### Step 2: Run the Script

Navigate to the `concat-csv` folder and run:

```bash
python main.py
```

### Step 3: Check the Output

The concatenated file `output.csv` will be created in the same directory as `main.py`.

### Example Execution

```bash
$ python main.py
Arxius CSV concatenats amb èxit!
```

**Output created:** `output.csv` containing all rows from all input files.

## How It Works

1. **Scans** the `input-csv` folder for all `.csv` files
2. **Reads** each CSV file using pandas
3. **Combines** all DataFrames while preserving row order
4. **Resets** the index to ensure continuous numbering
5. **Writes** the consolidated data to `output.csv`

## Input/Output Examples

### Input Files

**sales_q1.csv:**
```
ID,Product,Amount,Date
1,Widget A,100,2024-01-01
2,Widget B,150,2024-01-05
```

**sales_q2.csv:**
```
ID,Product,Amount,Date
3,Widget A,200,2024-04-01
4,Widget C,120,2024-04-10
```

### Output (output.csv)

```
ID,Product,Amount,Date
1,Widget A,100,2024-01-01
2,Widget B,150,2024-01-05
3,Widget A,200,2024-04-01
4,Widget C,120,2024-04-10
```

## Advanced Usage

### Processing Multiple Batches

Create separate folders for different datasets:

```bash
# Create a copy for another batch
cp -r concat-csv concat-csv-batch2

# Move different files to batch2
mv batch2_files/*.csv concat-csv-batch2/input-csv/

# Run on batch 2
cd concat-csv-batch2
python main.py
```

### Handling Different Column Orders

If CSV files have different column orders, you can modify `main.py`:

```python
import pandas as pd
import os

carpeta = 'input-csv'
llista_dfs = []

# Define desired column order
column_order = ['ID', 'Name', 'Amount', 'Date']

for arxiu in os.listdir(carpeta):
    if arxiu.endswith('.csv'):
        cami_complet = os.path.join(carpeta, arxiu)
        df = pd.read_csv(cami_complet)
        # Reorder columns if they exist
        df = df[[col for col in column_order if col in df.columns]]
        llista_dfs.append(df)

df_concatenat = pd.concat(llista_dfs, ignore_index=True)
df_concatenat.to_csv('output.csv', index=False)

print("CSV files concatenated successfully!")
```

### Filter Specific Columns

Concatenate only certain columns from input files:

```python
import pandas as pd
import os

carpeta = 'input-csv'
llista_dfs = []
columns_to_keep = ['ID', 'Name', 'Amount']

for arxiu in os.listdir(carpeta):
    if arxiu.endswith('.csv'):
        cami_complet = os.path.join(carpeta, arxiu)
        df = pd.read_csv(cami_complet, usecols=columns_to_keep)
        llista_dfs.append(df)

df_concatenat = pd.concat(llista_dfs, ignore_index=True)
df_concatenat.to_csv('output.csv', index=False)

print("Filtered CSV files concatenated successfully!")
```

### Remove Duplicates After Concatenation

```python
# After concatenating
df_concatenat = pd.concat(llista_dfs, ignore_index=True)

# Remove duplicate rows
df_concatenat = df_concatenat.drop_duplicates()

# Save without duplicates
df_concatenat.to_csv('output.csv', index=False)
```

## Common Issues & Troubleshooting

### Issue: "No module named 'pandas'"
**Solution:** Install pandas
```bash
pip install pandas
```

### Issue: "No such file or directory: 'input-csv'"
**Solution:** Create the `input-csv` folder
```bash
mkdir input-csv
```

### Issue: "No CSV files found"
**Solution:** Verify CSV files are in the `input-csv` folder with `.csv` extension

### Issue: Column mismatch or missing data
**Solution:** Ensure all input CSV files have the same column structure and data types

### Issue: Output file is empty
**Solution:** Check that input CSV files are not empty and contain valid data

### Issue: Rows are in unexpected order
**Solution:** The script processes files in directory order. To control order, rename files alphabetically (e.g., `01_sales.csv`, `02_sales.csv`)

## Performance Tips

### Large Files

For very large CSV files, consider processing in chunks:

```python
import pandas as pd
import os

carpeta = 'input-csv'

# Use chunking for memory efficiency
chunks = []
for arxiu in os.listdir(carpeta):
    if arxiu.endswith('.csv'):
        cami_complet = os.path.join(carpeta, arxiu)
        for chunk in pd.read_csv(cami_complet, chunksize=10000):
            chunks.append(chunk)

df_concatenat = pd.concat(chunks, ignore_index=True)
df_concatenat.to_csv('output.csv', index=False)
```

### Progress Indicator

Add progress tracking for long operations:

```python
import pandas as pd
import os

carpeta = 'input-csv'
llista_dfs = []
files = [f for f in os.listdir(carpeta) if f.endswith('.csv')]
total_files = len(files)

for i, arxiu in enumerate(files, 1):
    cami_complet = os.path.join(carpeta, arxiu)
    df = pd.read_csv(cami_complet)
    llista_dfs.append(df)
    print(f"Processed {i}/{total_files}: {arxiu}")

df_concatenat = pd.concat(llista_dfs, ignore_index=True)
df_concatenat.to_csv('output.csv', index=False)

print("CSV files concatenated successfully!")
```

## Scheduling Regular Runs

### On Linux/macOS (Cron)

Add to crontab to run daily:

```bash
crontab -e
```

Add this line to run every day at 2 AM:

```bash
0 2 * * * cd /path/to/concat-csv && python main.py
```

### On Windows (Task Scheduler)

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger and action to run: `python C:\path\to\concat-csv\main.py`

## Output Validation

After running the script, verify the output:

```bash
# Check output file exists
ls -lh output.csv

# Preview first few rows
head output.csv

# Count total rows
wc -l output.csv

# Verify with Python
import pandas as pd
df = pd.read_csv('output.csv')
print(f"Total rows: {len(df)}")
print(f"Columns: {df.columns.tolist()}")
```

## Data Quality Considerations

- **Encoding Issues:** If CSV files use different encodings, specify the encoding:
  ```python
  df = pd.read_csv(cami_complet, encoding='utf-8')
  ```

- **Date Parsing:** Ensure consistent date formats across files

- **Missing Values:** Check for NaN or empty cells that might cause issues

- **Duplicates:** Review if duplicates should be removed after concatenation

## Related Tools & Resources

- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [CSV Format Specification](https://tools.ietf.org/html/rfc4180)
- [Excel to CSV Conversion](https://support.microsoft.com/en-us/office/save-a-workbook-in-another-file-format-91a42b5d-d4c1-4a61-a856-879114b667d9)

## License

This tool is provided as-is for data processing purposes.

## Support

For issues or questions:
- Verify all CSV files are in the `input-csv` folder
- Check that files have valid CSV format
- Review pandas documentation for advanced usage
- Ensure sufficient disk space for output file
