USE [PH_PROD];
GO

/* Stored Procedure Written By Cary Hawkins for Origami Owl Copyright 2014. This Stored Procedure is used to update Group3 in the orders table
to what lane will most likely accept the order. This is not an iteration so there will always be a large level of error*/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE dbo.sp_laneacceptanceupdate
AS
BEGIN

    WITH Orders
	   AS ( SELECT
				A.order_id , 
				A.order_type , 
				A.order_status , 
				B.lane , 
				COUNT( b.location_id
					)AS [Locations Able to fill]
			FROM
				( 
				  SELECT
					    A.order_id , 
					    order_type , 
					    item_id , 
					    pieces_ordered , 
					    order_status
				    FROM
					    PH_PROD.dbxx.order_lines AS A
					    INNER JOIN
					    PH_PROD.dbxx.orders AS B
					    ON A.order_id
						  = 
						  B.order_id
				    WHERE B.order_status
						= 
						010
					 AND group1 NOT IN( 
				  SELECT
					    group1
				    FROM ph_prod.dbxx.orders AS a
				    GROUP BY
						   group1
				    HAVING COUNT( group1
							 )
						 > 
						 1
								   )
				)AS A
				INNER JOIN
				( 
				  SELECT
					    item_id , 
					    SUBSTRING( location_id , 1 , 1
							   )AS Lane , 
					    location_id , 
					    pieces_onhand - pieces_hard - pieces_commit - pieces_block - pieces_onhold AS Available
				    FROM PH_PROD.dbxx.item_location
				    WHERE location_type
						= 
						'PTL'
					 AND assign_flag
						= 
						'Y'
				)AS B
				ON A.item_id
				   = 
				   B.item_id
			WHERE Available
				 > 
				 pieces_ordered
			GROUP BY
				    A.order_id , 
				    B.lane , 
				    A.order_status , 
				    order_type
		 ) , Wave
	   AS ( SELECT
				order_id , 
				lane
			FROM( 
				 SELECT
					   order_id , 
					   lane
				   FROM( 
				 SELECT
					   order_id , 
					   order_type , 
					   Lane , 
					   [Locations Able to fill] , 
					   ROW_NUMBER(
							   )OVER( PARTITION BY order_id ORDER BY NEWID(
																 )
								   )AS Priority
				   FROM( 
				 SELECT
					   A.order_id , 
					   order_type , 
					   A.Lane , 
					   A.[Locations Able to fill] , 
					   COUNT( b.order_line
						   )AS [Total Items needed]
				   FROM
					   Orders AS A
					   INNER JOIN
					   PH_PROD.dbxx.order_lines AS B
					   ON A.order_id
						 = 
						 B.order_id
				   GROUP BY
						  A.order_id , 
						  A.Lane , 
						  A.[Locations able to fill] , 
						  order_type
				   HAVING COUNT( b.order_line
							)
						= 
						A.[Locations Able to fill]
					  )AS C
					  )AS D
				   WHERE Priority = 1
			    )AS e
		 )

	   UPDATE PH_PROD.dbxx.orders
		SET
		    group3 = A.Lane
		FROM Wave AS A
			INNER JOIN
			PH_PROD.dbxx.orders AS B
			ON A.order_id
			   = 
			   B.order_id
		WHERE
			 B.order_id IN( SELECT
							   order_id
						   FROM Wave
					    ) AND valadd_flag IS NULL;
END;
GO


