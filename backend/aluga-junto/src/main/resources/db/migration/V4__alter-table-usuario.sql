ALTER TABLE usuario
    ALTER COLUMN tipo TYPE varchar(20) USING (CASE
                                                  WHEN tipo = true THEN 'admin'
                                                  WHEN tipo = false THEN 'user'
        END);