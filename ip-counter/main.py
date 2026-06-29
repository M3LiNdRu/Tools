import csv
from collections import Counter

def get_top_ips(csv_file, top_n=20):
    try:
        # Read IPs from CSV file
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            ip_list = [row[1] for row in reader]  # We assume that IPs are in the second column
        
        # Count the frequency of each IP
        ip_counts = Counter(ip_list)
        
        # Get the top 'top_n' most repeated IPs
        top_ips = ip_counts.most_common(top_n)
        
        # Display the result
        print(f"The {top_n} most repeated IPs are:")
        for ip, count in top_ips:
            print(f"{ip}: {count} times")
        
        return top_ips
    except FileNotFoundError:
        print(f"The file {csv_file} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage example
csv_file = '11032025.1.csv'  # Name of the CSV file with the list of IPs
get_top_ips(csv_file)
