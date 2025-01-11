import matplotlib.pyplot as plt

# Dades simulades de CVEs descoberts per any
years = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024]
cve_counts = [1, 2, 1, 3, 2, 4, 3, 2, 5, 3]
title = "Nombre de CVE descoberts afectant Elasticsearch per any"
x_label = "Any"
y_label = "Nombre de CVE"

# Crear el gràfic
plt.figure(figsize=(10, 6))
plt.bar(years, cve_counts, color='skyblue', edgecolor='black')
plt.title(title, fontsize=14)
plt.xlabel(x_label, fontsize=12)
plt.ylabel(y_label, fontsize=12)
plt.xticks(years, rotation=45)
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Mostrar el gràfic
plt.tight_layout()
plt.show()
