import pandas as pd
import os

# Folder where CSV files are located
carpeta = 'input-csv'

# List to store DataFrames
llista_dfs = []

# Loop through all files in the folder
for arxiu in os.listdir(carpeta):
    if arxiu.endswith('.csv'):
        cami_complet = os.path.join(carpeta, arxiu)
        df = pd.read_csv(cami_complet)
        llista_dfs.append(df)

# Concatenate all DataFrames
df_concatenat = pd.concat(llista_dfs, ignore_index=True)

# Save the result to a new file
df_concatenat.to_csv('output.csv', index=False)

print("CSV files concatenated successfully!")
