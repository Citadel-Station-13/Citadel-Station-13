
#define PLAYERPOLL_EXTERNAL_CONFIGURATION
#define PLAYERPOLL_PROTECT_DATUM(path)			GENERAL_PROTECT_DATUM(path)
#define PLAYERPOLL_NEW_QUERY(text)				SSdbcore.NewQuery("[text]")
#define PLAYERPOLL_EXECUTE_QUERY(query)			query.Execute()
#define PLAYERPOLL_QUERY_NEXTROW(query)			query.NextRow()
#define PLAYERPOLL_QUERY_GETITEM(query, index)	query.item[index]
#define PLAYERPOLL_FORMAT_TABLE_NAME(name)		format_table_name(name)
