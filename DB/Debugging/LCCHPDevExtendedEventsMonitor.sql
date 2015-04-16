CREATE EVENT SESSION [usp_upFamilyWebScreen] ON SERVER 
ADD EVENT sqlserver.database_transaction_begin(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.database_transaction_end(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.module_end(SET collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.prepare_sql(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.rollback_tran_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.sp_statement_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))) 
ADD TARGET package0.ring_buffer
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


alter event session [usp_upFamilyWebScreen] on SERVER
STATE = start;

ALTER EVENT SESSION [usp_upFamilyWebScreen] 
ON SERVER 
DROP EVENT sqlserver.sql_batch_completed, 
DROP EVENT sqlserver.sql_statement_completed; 
GO


-- Query the XML to get the Target Data 
SELECT 
    event.value('(event/@name)[1]', 'varchar(50)') AS event_name, 
    DATEADD(hh, 
            DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP), 
            event.value('(event/@timestamp)[1]', 'datetime2')) AS [timestamp], 
    ISNULL(event.value('(event/data[@name="statement"]/value)[1]', 'nvarchar(max)'), 
            event.value('(event/data[@name="batch_text"]/value)[1]', 'nvarchar(max)')) AS [stmt/btch_txt], 
    event.value('(event/action[@name="sql_text"]/value)[1]', 'nvarchar(max)') as [sql_text] 
FROM 
(   SELECT n.query('.') as event 
    FROM 
    ( 
        SELECT CAST(target_data AS XML) AS target_data 
        FROM sys.dm_xe_sessions AS s    
        JOIN sys.dm_xe_session_targets AS t 
            ON s.address = t.event_session_address 
        WHERE s.name = 'usp_upFamilyWebScreen' 
          AND t.target_name = 'ring_buffer' 
    ) AS sub 
    CROSS APPLY target_data.nodes('RingBufferTarget/event') AS q(n) 
) AS tab
order by timestamp desc