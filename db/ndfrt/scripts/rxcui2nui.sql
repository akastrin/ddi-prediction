SELECT RXCUI, SCUI
FROM RXNCONSO
WHERE SAB="NDFRT"
GROUP BY RXCUI, SCUI;
