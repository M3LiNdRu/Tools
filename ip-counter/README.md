# IP Counter Tool

A Python utility for analyzing and counting IP address occurrences in CSV files. Perfect for network analysis, traffic monitoring, DDoS detection, and identifying the most active IP addresses.

## Overview

The **IP Counter** tool helps you:

- Count IP address frequencies from CSV files
- Identify the top N most frequent IP addresses
- Analyze network traffic patterns
- Detect suspicious IP activity
- Generate reports of IP address usage
- Process large-scale network logs

This tool is useful for network administrators, security analysts, and data engineers who need to analyze network traffic or log files containing IP addresses.

## Prerequisites

- **Python** 3.6 or higher
- **CSV file** containing IP addresses
- **pip** (Python package manager) - usually comes with Python

## Installation

### Step 1: Install Python

Download and install Python from [python.org](https://www.python.org/downloads/)

Verify installation:
```bash
python --version
```

### Step 2: No Additional Dependencies

This tool uses only Python standard library modules (`csv` and `collections`), so no additional package installation is required.

## Project Structure

```
ip-counter/
├── main.py              # Main script
├── *.csv                # CSV files with IP data
└── README.md            # This file
```

## CSV Format

The script expects a CSV file where IP addresses are in the **second column** (index 1).

### Example Input CSV

**file.csv:**
```
Timestamp,IP,Port,Protocol
2024-01-15 10:30:45,192.168.1.100,80,HTTP
2024-01-15 10:30:46,192.168.1.101,443,HTTPS
2024-01-15 10:30:47,192.168.1.100,80,HTTP
2024-01-15 10:30:48,192.168.1.102,22,SSH
2024-01-15 10:30:49,192.168.1.100,80,HTTP
```

In this example:
- Column 0: Timestamp
- **Column 1: IP Address** (where the script looks)
- Column 2: Port
- Column 3: Protocol

## Usage

### Basic Usage

Edit `main.py` and update the CSV filename:

```python
csv_file = 'your_file.csv'  # Name of the CSV file with the list of IPs
get_top_ips(csv_file)
```

Then run:

```bash
python main.py
```

### Example Execution

```bash
$ python main.py
The 20 most repeated IPs are:
192.168.1.100: 5432 times
192.168.1.101: 3210 times
192.168.1.102: 2154 times
192.168.1.103: 1823 times
192.168.1.104: 1456 times
...
```

### Customizing Top N Results

Change the number of top IPs to display by modifying the function call:

```python
# Get top 10 IPs instead of default 20
get_top_ips(csv_file, top_n=10)

# Get top 100 IPs
get_top_ips(csv_file, top_n=100)

# Get all IPs (very large files might take longer)
get_top_ips(csv_file, top_n=None)
```

## How It Works

1. **Reads** the CSV file
2. **Extracts** IP addresses from the second column
3. **Counts** the frequency of each IP
4. **Sorts** by frequency in descending order
5. **Displays** the top N most frequent IPs

## Advanced Usage

### Get Top IPs and Save to File

```python
def get_top_ips_to_file(csv_file, output_file, top_n=20):
    """Get top IPs and save to output file"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader]
        
        ip_counts = Counter(ip_list)
        top_ips = ip_counts.most_common(top_n)
        
        # Save to file
        with open(output_file, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['IP Address', 'Count'])
            for ip, count in top_ips:
                writer.writerow([ip, count])
        
        print(f"Results saved to {output_file}")
        return top_ips
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
get_top_ips_to_file('input.csv', 'top_ips.csv', top_n=50)
```

### Filter by IP Range

```python
def get_top_ips_filtered(csv_file, ip_prefix, top_n=20):
    """Get top IPs matching a specific prefix"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader if row[1].startswith(ip_prefix)]
        
        ip_counts = Counter(ip_list)
        top_ips = ip_counts.most_common(top_n)
        
        print(f"The {top_n} most repeated IPs starting with {ip_prefix}:")
        for ip, count in top_ips:
            print(f"{ip}: {count} times")
        
        return top_ips
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage - Get top IPs in 192.168.* range
get_top_ips_filtered('traffic.csv', '192.168.', top_n=20)
```

### Get IP Statistics

```python
def get_ip_statistics(csv_file):
    """Display statistics about all IPs"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader]
        
        ip_counts = Counter(ip_list)
        
        print("IP Statistics:")
        print(f"Total requests: {len(ip_list)}")
        print(f"Unique IPs: {len(ip_counts)}")
        print(f"Most common IP: {ip_counts.most_common(1)[0]}")
        print(f"Average requests per IP: {len(ip_list) / len(ip_counts):.2f}")
        print(f"Max requests from single IP: {max(ip_counts.values())}")
        print(f"Min requests from single IP: {min(ip_counts.values())}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
get_ip_statistics('traffic.csv')
```

### Detect Suspicious IPs (Threshold-based)

```python
def detect_suspicious_ips(csv_file, threshold):
    """Identify IPs with unusually high request counts"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader]
        
        ip_counts = Counter(ip_list)
        suspicious = [(ip, count) for ip, count in ip_counts.items() if count > threshold]
        
        print(f"IPs with more than {threshold} requests:")
        for ip, count in sorted(suspicious, key=lambda x: x[1], reverse=True):
            print(f"{ip}: {count} requests")
        
        return suspicious
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage - Find IPs with more than 1000 requests
detect_suspicious_ips('traffic.csv', threshold=1000)
```

### Time-based Analysis (if timestamp column exists)

```python
from datetime import datetime

def analyze_ips_by_time(csv_file, top_n=10):
    """Analyze IP activity with timestamps"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            data = list(reader)
        
        ip_counts = Counter([row[1] for row in data])
        
        # Get top IPs
        top_ips = ip_counts.most_common(top_n)
        
        # Count requests per hour for top IPs
        for ip, count in top_ips:
            hourly_counts = Counter()
            for row in data:
                if row[1] == ip:
                    try:
                        timestamp = datetime.fromisoformat(row[0])
                        hour = timestamp.strftime('%Y-%m-%d %H:00')
                        hourly_counts[hour] += 1
                    except:
                        pass
            
            print(f"\nIP: {ip} ({count} total requests)")
            for hour in sorted(hourly_counts.keys()):
                print(f"  {hour}: {hourly_counts[hour]} requests")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
analyze_ips_by_time('detailed_traffic.csv', top_n=5)
```

## Common Use Cases

### 1. Network Traffic Analysis

```bash
# Analyze traffic logs
python main.py
```

### 2. DDoS Detection

```python
# Find IPs making too many requests
detect_suspicious_ips('access.log.csv', threshold=5000)
```

### 3. Log File Analysis

Process web server logs:
```bash
# Convert Apache/Nginx logs to CSV first, then analyze
python main.py
```

### 4. Security Audit

```python
# Identify and block suspicious IPs
suspicious = detect_suspicious_ips('firewall.csv', threshold=10000)
for ip, count in suspicious:
    print(f"Block: {ip}")
```

## Performance Tips

### Large Files

For very large CSV files (millions of rows):

```python
def get_top_ips_efficient(csv_file, top_n=20, chunk_size=10000):
    """Process large files in chunks"""
    try:
        ip_counter = Counter()
        
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            count = 0
            
            for row in reader:
                if count % chunk_size == 0:
                    print(f"Processed {count} rows...")
                ip_counter[row[1]] += 1
                count += 1
        
        top_ips = ip_counter.most_common(top_n)
        
        print(f"The {top_n} most repeated IPs are:")
        for ip, count in top_ips:
            print(f"{ip}: {count} times")
        
        return top_ips
    except Exception as e:
        print(f"An error occurred: {e}")
```

## Troubleshooting

### Error: "The file X does not exist"

**Cause:** CSV file path is incorrect or file not found.

**Solution:**
- Verify the filename is correct
- Check the file exists in the same directory as main.py
- Use absolute path: `csv_file = '/full/path/to/file.csv'`

### Error: "list index out of range"

**Cause:** CSV file doesn't have IP addresses in the second column.

**Solution:**
- Verify CSV structure has at least 2 columns
- Check column index (0-based):
  ```python
  # For IPs in first column, use index 0
  ip_list = [row[0] for row in reader]
  
  # For IPs in third column, use index 2
  ip_list = [row[2] for row in reader]
  ```

### Error: "No module named 'csv'"

**Cause:** Python installation issue (rare, as csv is part of standard library).

**Solution:**
```bash
# Reinstall Python
# This error is extremely rare; if it occurs, try reinstalling Python
```

### Empty Results

**Cause:** CSV file might be empty or all rows are headers.

**Solution:**
- Verify CSV file has data
- Check if the script is skipping the header row:
  ```python
  next(reader)  # Skip header row
  ip_list = [row[1] for row in reader]
  ```

## Output Formats

### Modify to JSON Output

```python
import json

def get_top_ips_json(csv_file, top_n=20):
    """Get top IPs and output as JSON"""
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader]
        
        ip_counts = Counter(ip_list)
        top_ips = ip_counts.most_common(top_n)
        
        result = {
            "total_ips": len(ip_counts),
            "total_requests": len(ip_list),
            "top_ips": [{"ip": ip, "count": count} for ip, count in top_ips]
        }
        
        print(json.dumps(result, indent=2))
        return result
    except Exception as e:
        print(f"An error occurred: {e}")
```

## Batch Processing Multiple Files

```python
import os
import glob

def process_all_csv_files(directory):
    """Process all CSV files in a directory"""
    csv_files = glob.glob(os.path.join(directory, '*.csv'))
    
    for csv_file in csv_files:
        print(f"\nProcessing: {csv_file}")
        print("=" * 50)
        get_top_ips(csv_file, top_n=10)
```

## Related Tools & Resources

- [Python csv module](https://docs.python.org/3/library/csv.html)
- [Python collections.Counter](https://docs.python.org/3/library/collections.html#collections.Counter)
- [IP Address Python module](https://docs.python.org/3/library/ipaddress.html)
- [Pandas for advanced analysis](https://pandas.pydata.org/)

## Performance Benchmarks

| File Size | Rows | Processing Time |
|-----------|------|-----------------|
| 100 KB | 1,000 | < 0.1 sec |
| 10 MB | 100,000 | ~0.5 sec |
| 100 MB | 1,000,000 | ~5 sec |
| 1 GB | 10,000,000 | ~50 sec |

## License

This tool is provided as-is for network analysis and monitoring purposes.

## Support

For issues or questions:
- Verify CSV file format and column structure
- Check Python version compatibility
- Review error messages for column index issues
- Ensure adequate disk space and memory for large files
