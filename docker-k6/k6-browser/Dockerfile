# Usa la imatge oficial de k6
FROM grafana/k6:master-with-browser

# Crea un directori de treball
WORKDIR /k6

# Copia el script de test al directori de treball
COPY test-script.js .

# Comanda per executar el test de k6
ENTRYPOINT ["k6", "run", "test-script.js"]