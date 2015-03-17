WITH Locations AS (SELECT        item_id, location_id, CASE WHEN substring(location_id, 1, 4) = 'PREP' THEN 'Prep' WHEN SUBSTRING(location_id, 1, 3) IN ('S01', 'S02') 
                                                                     THEN 'Quarantine' WHEN SUBSTRING(location_id, 1, 3) = 'S18' THEN 'POST QC/PRE PREP' WHEN SUBSTRING(location_id, 1, 2) 
                                                                     = 'QC' THEN 'QC' WHEN location_type = 'PTL' THEN 'On Pick Lines' WHEN SUBSTRING(location_id, 1, 2) IN ('LM', 'UM') 
                                                                     THEN 'Completed for Backstock' WHEN location_id LIKE 'R-%' THEN 'Receiving' WHEN SUBSTRING(location_id, 1, 3) IN ('S07', 'S08') 
                                                                     THEN 'PRE QC' WHEN SUBSTRING(location_id, 1, 3) IN ('S24', 'S25', 'S26','S27','S28') THEN 'POST PREP' WHEN location_id IN ('FIN PREP', 'FINPREP') 
                                                                     THEN 'POST PREP' ELSE [location_id] END AS [Location Type], pieces_onhand - (pieces_onhold + pieces_hard) AS Available
                                            FROM            PH_PROD.dbxx.item_location
											WHERE location_id not like 'UMC%')
    SELECT        Sales.item_id, Sales.[Total Units] AS [Units Open], [Pre QC].location_id, MAX([Pre QC].[On Hand]) AS [Pre QC],ISNULL(QC.[On Hand], 0) AS QC,[Pre Prep].location_id ,ISNULL([Pre Prep].[On Hand], 0) 
                              AS [Pre Prep], ISNULL(Prep.[On Hand], 0) AS Prep,[Post Prep].location_id ,ISNULL([Post Prep].[On Hand], 0) AS [Post Prep],[Backstock].location_id, MAX(Backstock.[On Hand]) AS Backstock, 
                            ISNULL(A.[OH],0) AS [A],ISNULL(B.[OH],0)AS B,ISNULL(C.[OH],0)AS C,ISNULL(D.[OH],0)AS D,ISNULL(E.[OH],0)AS E,ISNULL(F.[OH],0)AS F,ISNULL(G.[OH],0)AS G,ISNULL(H.[OH],0)AS H
     FROM            (SELECT        item_id, SUM(pieces_ordered) AS [Total Units]
                               FROM            PH_PROD.dbxx.order_lines AS A
                               GROUP BY item_id) AS Sales LEFT OUTER JOIN
                                  (SELECT        item_id,location_id, MAX(Available) AS [On Hand]
                                    FROM            Locations AS Locations_7
                                    WHERE        ([Location Type] = 'PREP')
                                    GROUP BY item_id, location_id) AS Prep ON Sales.item_id = Prep.item_id LEFT OUTER JOIN
                                  (SELECT        item_id, location_id,MAX(Available) AS [On Hand]
                                    FROM            Locations AS Locations_6
                                    WHERE        ([Location Type] = 'Completed For BackStock')
                                    GROUP BY item_id, [location_id]) AS Backstock ON Sales.item_id = Backstock.item_id LEFT OUTER JOIN
                                  (SELECT        item_id, location_id,MAX(Available) AS [On Hand]
                                    FROM            Locations AS Locations_5
                                    WHERE        ([Location Type] = 'QC')
                                    GROUP BY item_id, location_id) AS QC ON Prep.item_id = QC.item_id LEFT OUTER JOIN
                                  (SELECT        item_id, location_id,MAX(Available) AS [On Hand]
                                    FROM            Locations AS Locations_4
                                    WHERE        ([Location Type] = 'Pre Prep')
                                    GROUP BY item_id, location_id) AS [Pre Prep] ON Sales.item_id = [Pre Prep].item_id LEFT OUTER JOIN
                                  (SELECT	item_id, location_id,SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'A-'
								  GROUP BY item_id,location_id) AS [A] On Sales.item_id = A.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id,location_id, SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'B-'
								  GROUP BY item_id,location_id) AS [B] On Sales.item_id = B.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id, location_id,SUM(pieces_onhand)- SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'C-'
								  GROUP BY item_id,location_id) AS [C] On Sales.item_id = C.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id, location_id,SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'D-'
								  GROUP BY item_id,location_id) AS [D] On Sales.item_id = D.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id,location_id, SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'E-'
								  GROUP BY item_id,location_id) AS [E] On Sales.item_id = E.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id, location_id,SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'F-'
								  GROUP BY item_id,location_id) AS [F] On Sales.item_id = F.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id,location_id, SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'G-'
								  GROUP BY item_id,location_id) AS [G] On Sales.item_id = G.item_id
								  LEFT OUTER JOIN
								   (SELECT	item_id,location_id, SUM(pieces_onhand)-SUM(pieces_hard) AS [OH]
								  FROM PH_PROD.dbxx.item_location
								  WHERE SUBSTRING(location_id,1,2) = 'H-'
								  GROUP BY item_id,location_id) AS [H] On Sales.item_id = H.item_id
								  LEFT OUTER JOIN
                                  (SELECT        item_id, location_id,SUM(Available) AS [On Hand]
                                    FROM            Locations AS Locations_2
                                    WHERE        ([Location Type] = 'Pre QC')
                                    GROUP BY item_id, location_id) AS [Pre QC] ON Sales.item_id = [Pre QC].item_id LEFT OUTER JOIN
                                  (SELECT        item_id, location_id, SUM(Available) AS [On Hand]
                                    FROM            Locations AS Locations_1
                                    WHERE        ([Location Type] = 'Post Prep')
                                    GROUP BY item_id, location_id) AS [Post Prep] ON Sales.item_id = [Post Prep].item_id
									GROUP BY Sales.item_id, Sales.[Total Units], [Pre QC].location_id,ISNULL(QC.[On Hand], 0),[Pre Prep].location_id ,ISNULL([Pre Prep].[On Hand], 0) 
                             , ISNULL(Prep.[On Hand], 0) ,[Post Prep].location_id ,ISNULL([Post Prep].[On Hand], 0),[Backstock].location_id,
                            ISNULL(A.[OH],0) ,ISNULL(B.[OH],0),ISNULL(C.[OH],0),ISNULL(D.[OH],0),ISNULL(E.[OH],0),ISNULL(F.[OH],0),ISNULL(G.[OH],0),ISNULL(H.[OH],0)
							ORDER BY [Units Open] DESC


									