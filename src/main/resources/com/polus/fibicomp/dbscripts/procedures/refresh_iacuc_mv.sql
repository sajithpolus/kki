CREATE  PROCEDURE refresh_iacuc_mv(
)
BEGIN

TRUNCATE TABLE IACUC_MV;
INSERT INTO IACUC_MV
(
PROTOCOL_ID,
DOCUMENT_NUMBER,
PROTOCOL_NUMBER,
SEQUENCE_NUMBER,
VER_NBR,
TITLE,
LEAD_UNIT_NUMBER,
LEAD_UNIT,
PROTOCOL_TYPE_CODE,
PROTOCOL_TYPE,
STATUS_CODE,
STATUS,
EXPIRATION_DATE,
UPDATE_TIMESTAMP,
UPDATE_USER,
PERSON_ID,
FULL_NAME
)
SELECT 				
	T1.PROTOCOL_ID,
	T1.DOCUMENT_NUMBER,
	T1.PROTOCOL_NUMBER,
	T1.SEQUENCE_NUMBER,
	T1.VER_NBR,
	T1.TITLE,
	T4.UNIT_NUMBER AS LEAD_UNIT_NUMBER,
	T5.UNIT_NAME AS LEAD_UNIT,
	T1.PROTOCOL_TYPE_CODE,
	T2.DESCRIPTION AS PROTOCOL_TYPE,
	T1.PROTOCOL_STATUS_CODE AS STATUS_CODE,
	T3.DESCRIPTION AS STATUS,
	T1.EXPIRATION_DATE,
	T1.UPDATE_TIMESTAMP,
	T1.UPDATE_USER,
	T6.PERSON_ID,
	T6.FULL_NAME
FROM IACUC_PROTOCOL T1
INNER JOIN IACUC_PROTOCOL_TYPE T2 ON T1.PROTOCOL_TYPE_CODE = T2.PROTOCOL_TYPE_CODE
INNER JOIN IACUC_PROTOCOL_STATUS T3 ON T1.PROTOCOL_STATUS_CODE = T3.PROTOCOL_STATUS_CODE
LEFT OUTER JOIN IACUC_PROTOCOL_UNITS T4 ON T1.PROTOCOL_NUMBER = T4.PROTOCOL_NUMBER 
								AND T1.SEQUENCE_NUMBER = T4.SEQUENCE_NUMBER
								AND T4.LEAD_UNIT_FLAG = 'Y'
LEFT OUTER JOIN UNIT T5 ON T4.UNIT_NUMBER = T5.UNIT_NUMBER
LEFT OUTER JOIN IACUC_PROTOCOL_PERSONS T6 ON T1.PROTOCOL_ID=T6.PROTOCOL_ID;
COMMIT;

END