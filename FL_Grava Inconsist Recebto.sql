DECLARE
      i INTEGER := 0;

      BEGIN
        FOR t IN (SELECT A.SEQAUXNOTAFISCAL, A.SEQNF, A.NUMERONF, A.NROEMPRESA, A.SEQPESSOA, B.SEQAUXNFITEM, B.SEQPRODUTO, C.SEQINCONSISTENCIA,
                         C.TIPOINCONSIST, C.CODINCONSIST, SYSDATE DATALOG, C.DESCRICAO
                    FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM           B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                                      INNER JOIN CONSINCO.MLF_AUXNFINCONSISTENCIA C ON C.SEQAUXNOTAFISCAL = A.SEQAUXNOTAFISCAL AND C.SEQAUXNFITEM = B.SEQAUXNFITEM
                   WHERE 1=1
                     AND A.NUMERONF != 0
                     AND A.DTAHORLANCTO > TRUNC(SYSDATE) -1
                     AND NOT EXISTS (SELECT 1 FROM CONSINCO.NAGT_INCONSISTRECEBTO_LOG X 
                                             WHERE 1=1 
                                               AND X.SEQAUXNOTAFISCAL = A.SEQAUXNOTAFISCAL 
                                               AND X.SEQPRODUTO = B.SEQPRODUTO 
                                               AND X.SEQINCONSISTENCIA = C.SEQINCONSISTENCIA))

     LOOP
      BEGIN
        i := i+1;
        INSERT INTO CONSINCO.NAGT_INCONSISTRECEBTO_LOG X (SEQAUXNOTAFISCAL, SEQNF, NUMERONF, NROEMPRESA, SEQPESSOA,
                                                          SEQAUXNFITEM, SEQPRODUTO, SEQINCONSISTENCIA, TIPOINCONSIST, CODINCONSIST, DATALOG, DESCRICAO)
                                                  VALUES (T.SEQAUXNOTAFISCAL, T.SEQNF, T.NUMERONF, T.NROEMPRESA, T.SEQPESSOA,
                                                          T.SEQAUXNFITEM, T.SEQPRODUTO, T.SEQINCONSISTENCIA, T.TIPOINCONSIST, T.CODINCONSIST, T.DATALOG, T.DESCRICAO);
        IF i = 1 THEN COMMIT;
        i := 0;
        END IF;

      END;
     END LOOP;
    COMMIT;
   END;