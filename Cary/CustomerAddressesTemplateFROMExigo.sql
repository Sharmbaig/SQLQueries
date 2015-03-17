SELECT 
		c.CustomerID AS cust_id,
		c.MainAddress1 AS b_address1,
		c.MainAddress2 AS b_address2,
		c.MainAddress3 AS b_address3,
		c.MainCity AS b_city,
		c.MainState AS b_state,
		c.MainZip AS b_zip,
		c.LastName+','+FirstName AS s_contact,
		c.Email AS email_address1,
		c.Phone AS s_phone,
		CASE WHEN c.MailAddress1 = ''
		THEN c.MainAddress1
		ELSE c.MailAddress1
		END AS s_address1,
		CASE WHEN c.MailAddress2 = ''
		THEN c.MainAddress2
		ELSE c.Mailaddress2 END AS s_address2,
		CASE WHEN c.MailAddress3 =''
		THEN c.MainAddress3
		ELSE c.MailAddress3 END AS s_address3,
		CASE WHEN c.MailCity =''
		THEN c.MainCity
		ELSE c.MailCity END AS s_city,
		CASE WHEN c.MailZip = ''
		THEN c.MainZip
		ELSE MailZip END AS s_zip
 from dbo.Customers c
WHERE CUSTOMERID  IN ()