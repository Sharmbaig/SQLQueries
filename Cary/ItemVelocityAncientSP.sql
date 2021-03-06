USE [PH_ANCIENT_PROD]
GO
/****** Object:  StoredProcedure [dbxx].[rpt_item_velocity]    Script Date: 3/6/2015 11:06:22 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbxx].[rpt_item_velocity]
  @warehouse_id char(5) = null,
  @owner_id     char(5) = null,
  @item_class   char(15) = null,
  @item_id      char(30) = null,
  @order_type   char(10) = null,
  @date_fr      char(20) = null,
  @date_to      char(20) = null,
  @show_style   char(1)  = 'N'
as begin
  declare @d_date_fr datetime
  declare @d_date_to datetime
  declare @sys_retval int, @sys_rowcount numeric(10,0), @sys_error numeric(10,0), @sys_rowid int, @sys_maxrowid int, @sys_err_msg nvarchar(4000)
  create table #listfile
   (owner_id           char(5)       null          
   ,item_id            char(30)      null    
   ,description        char(50)      null
   ,style_id           char(30)      NULL
   ,color_id           char(30)      NULL
   ,size_x             char(6)       NULL
   ,size_y             char(6)       NULL
   ,current_velocity   int           NULL
   ,future_velocity    int           null
   ,work_type          char(10)      null
   ,pieces             numeric(10,0) null
   ,order_id           char(20)      null
   ,order_rel          char(10)      null
   ,sort_order         char(70)      NULL
  ) 
  if isnull(@order_type, '') = '' or upper(isnull(@order_type, 'ALL')) = 'ALL' or upper(isnull(@order_type, '(ALL)')) = '(ALL)' begin
    select @order_type = null 
  end   
  if isnull(@item_class, '') = '' or upper(isnull(@item_class, 'ALL')) = 'ALL' or upper(isnull(@item_class, '(ALL)')) = '(ALL)' begin
    select @item_class = null 
  end      
  if isnull(@item_id, '') = '' or upper(isnull(@item_id, 'ALL')) = 'ALL' or upper(isnull(@item_id, '(ALL)')) = '(ALL)' begin
    select @item_id = null 
  end         
  if @date_fr is null or rtrim(@date_fr) = '' begin
    select @d_date_fr = null 
  end else begin
    select @d_date_fr = convert(datetime,@date_fr,1) 
  end  
  if @date_to is null or rtrim(@date_to) = '' begin
    select @d_date_to = null 
  end else begin
    select @d_date_to = convert(datetime,@date_to,1) 
    select @d_date_to = dateadd(day, 1, @d_date_to)  
  end  
  --insert into #listfile
  --select it.owner_id   
  --      ,it.item_id
  --      ,im.description
  --      ,isnull(im.style_id, '')
  --      ,isnull(im.color_id, '') 
  --      ,isnull(im.size_x, '')    
  --      ,isnull(im.size_y, '')    
  --      ,im.current_velocity
  --      ,im.future_velocity
  --      ,substring(it.if_tran_code, 1, 3) as work_type
  --      ,it.pieces
  --      ,it.order_id
  --      ,it.order_rel
  --      ,''          --as sort_order
  --  FROM dbxx.if_transaction it with(nolock)
  --      ,dbxx.orders od with(nolock)
  --      ,dbxx.item_master im with(nolock)
  -- WHERE it.warehouse_id_from = od.warehouse_id
  --   and it.owner_id = od.owner_id
  --   and it.order_id = od.order_id
  --   and it.order_rel = od.release_num
  --   and it.if_tran_code in ( 'BOP-PICK', 'COP-PICK', 'COP-PICK-F', 'COP-PICK-X', 'FOP-PICK', 'FOP-PICK-F', 'FOP-PICK-X', 'POP-PICK', 'POP-PICK-F', 'POP-PICK-X')
  --   and it.owner_id = im.owner_id
  --   and it.item_id = im.item_id
  --   and it.warehouse_id_from = @warehouse_id
  --   and it.owner_id = @owner_id
  --   and (@order_type is null or @order_type = od.order_type)
  --   and (@item_class is null or @item_class = im.item_class)
  --   and (@item_id is null or im.item_id =@item_id)
  --   and (@d_date_fr is null or it.activity_date >= @d_date_fr)
  --   and (@d_date_to is null or it.activity_date <  @d_date_to) 
  --if @@error!=0 return -100
  insert into #listfile
  select it.owner_id   
        ,it.item_id
        ,im.description
        ,isnull(im.style_id, '') 
        ,isnull(im.color_id, '') 
        ,isnull(im.size_x, '')  
        ,isnull(im.size_y, '')    
        ,im.current_velocity
        ,im.future_velocity
        ,substring(it.if_tran_code, 1, 3) as work_type
        ,it.pieces
        ,it.order_id
        ,it.order_rel
        ,''                    --as sort_order
    FROM dbxx.if_transaction it with(nolock)
        ,dbxx.hi_orders od with(nolock)
        ,PH_PROD.dbxx.item_master im with(nolock)
   WHERE it.warehouse_id_from = od.warehouse_id
     and it.owner_id = od.owner_id
     and it.order_id = od.order_id
     and it.order_rel = od.release_num
     and it.if_tran_code in ( 'BOP-PICK', 'COP-PICK', 'COP-PICK-F', 'COP-PICK-X', 'FOP-PICK', 'FOP-PICK-F', 'FOP-PICK-X', 'POP-PICK', 'POP-PICK-F', 'POP-PICK-X')
     and it.owner_id = im.owner_id
     and it.item_id = im.item_id
     and it.warehouse_id_from = @warehouse_id
     and it.owner_id = @owner_id
     and (@order_type is null or @order_type = od.order_type)
     and (@item_class is null or @item_class = im.item_class)
     and (@item_id is null or im.item_id =@item_id)
     and (@d_date_fr is null or it.activity_date >= @d_date_fr)
     and (@d_date_to is null or it.activity_date <= @d_date_to) 
  if @@error!=0 return -100
  if @show_style = 'Y' begin
    update #listfile set sort_order = ltrim(rtrim(style_id)) + ' / ' + 
                                     ltrim(rtrim(color_id)) + ' / ' + 
                                     ltrim(rtrim(size_x))   + ' / ' + 
                                     ltrim(rtrim(size_y)) 
    if @@error!=0 return -100
  end else begin
    update #listfile set sort_order = item_id 
    if @@error!=0 return -100
  end  
  resultset:
  select tp.owner_id
        ,tp.item_id
        ,tp.description
        ,tp.style_id 
        ,tp.color_id
        ,tp.size_x
        ,tp.size_y
        ,tp.current_velocity
        ,tp.future_velocity
        ,sum(tp.pieces) as pieces
        ,count(1) as pick
        ,count(distinct rtrim(tp.order_id) + "++----" + rtrim(tp.order_rel)) as order_cnt
        ,sum(case when tp.work_type = 'FOP' or tp.work_type = 'BOP' then 1 else 0 end) as pick_pallet
        ,sum(case when tp.work_type = 'COP' then 1 else 0 end) as pick_case
        ,sum(case when tp.work_type = 'POP' then 1 else 0 end) as pick_piece
        ,tp.sort_order
    from #listfile tp
   group by 
         tp.owner_id
        ,tp.item_id
        ,tp.description
        ,tp.style_id 
        ,tp.color_id
        ,tp.size_x
        ,tp.size_y
        ,tp.current_velocity
        ,tp.future_velocity
        ,tp.sort_order
   order by 
         tp.owner_id
        ,tp.sort_order 
  if @@error!=0 return -100
end  
