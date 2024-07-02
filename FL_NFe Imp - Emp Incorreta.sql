-- Corrige a empresa incorreta importada na tabela MRL_NFEIMPORTACAO
BEGIN
  FOR t IN (SELECT * FROM CONSINCO.NAGV_IMPNFEEMPINCORRETA X WHERE X.DTAEMISSAOC5 BETWEEN DATE '2024-06-01' AND SYSDATE +1)
    LOOP
      UPDATE CONSINCO.MRL_NFEIMPORTACAO I SET I.NROEMPRESA    = T.EMP_CERTA 
                                        WHERE I.SEQNOTAFISCAL = T.SEQNOTAFISCAL;
    END LOOP;
    
    COMMIT;
    
END;