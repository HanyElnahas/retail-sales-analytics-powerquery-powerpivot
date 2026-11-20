// Power Query (M) - Orders query
// Copied from Advanced Editor. Source paths are local; point them to your own data folder.
let
    Source = Folder.Files("D:\Data Analysis\Material P2\PowerQuery\Orders"),
    #"Filtered Hidden Files1" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
    #"Invoke Custom Function1" = Table.AddColumn(#"Filtered Hidden Files1", "Transform File", each #"Transform File"([Content])),
    #"Renamed Columns1" = Table.RenameColumns(#"Invoke Custom Function1", {"Name", "Source.Name"}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Renamed Columns1", {"Source.Name", "Transform File"}),
    #"Expanded Table Column1" = Table.ExpandTableColumn(#"Removed Other Columns1", "Transform File", Table.ColumnNames(#"Transform File"(#"Sample File"))),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Table Column1",{{"CustomerID", Int64.Type}, {"ProductID", Int64.Type}, {"OrderID", Int64.Type}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each [ProductID] <> null and [ProductID] <> ""),
    #"Filtered Rows1" = Table.SelectRows(#"Filtered Rows", each [OrderDate] <> null and [OrderDate] <> ""),
    #"Filtered Rows2" = Table.SelectRows(#"Filtered Rows1", each [Quantity] <> null and [Quantity] <> ""),
    #"Changed Type1" = Table.TransformColumnTypes(#"Filtered Rows2",{{"Quantity", Int64.Type}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"OrderID"}),
    #"Added Index" = Table.AddIndexColumn(#"Removed Columns", "Index", 1, 1, Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Added Index",{{"Index", "OrderID"}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Renamed Columns",{"Source.Name", "OrderID", "CustomerID", "ProductID", "OrderDate", "Quantity"}),
    #"Replaced Value" = Table.ReplaceValue(#"Reordered Columns","/","-",Replacer.ReplaceText,{"OrderDate"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Replaced Value", "OrderDate", Splitter.SplitTextByDelimiter("-", QuoteStyle.Csv), {"OrderDate.1", "OrderDate.2", "OrderDate.3"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"OrderDate.1", Int64.Type}, {"OrderDate.2", Int64.Type}, {"OrderDate.3", Int64.Type}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Changed Type2",{"Source.Name", "OrderID", "CustomerID", "ProductID", "Quantity", "OrderDate.1", "OrderDate.2", "OrderDate.3"}),
    #"Added Conditional Column" = Table.AddColumn(#"Reordered Columns1", "Custom", each if [OrderDate.1] > 31 then [OrderDate.1] else if [OrderDate.3] > 31 then [OrderDate.3] else "not found"),
    #"Filtered Rows3" = Table.SelectRows(#"Added Conditional Column", each true),
    #"Renamed Columns2" = Table.RenameColumns(#"Filtered Rows3",{{"Custom", "Year"}}),
    #"Inserted Text Between Delimiters" = Table.AddColumn(#"Renamed Columns2", "Text Between Delimiters", each Text.BetweenDelimiters([Source.Name], "_", "."), type text),
    #"Renamed Columns3" = Table.RenameColumns(#"Inserted Text Between Delimiters",{{"Text Between Delimiters", "Month"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns3",{"Source.Name"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Removed Columns1",{{"Month", Int64.Type}, {"Year", Int64.Type}}),
    #"Sorted Rows" = Table.Sort(#"Changed Type3",{{"Month", Order.Ascending}}),
    #"Filtered Rows4" = Table.SelectRows(#"Sorted Rows", each true),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows4", "Custom", each if [OrderDate.1]<=31 and [OrderDate.1]<>[Month] then [OrderDate.1]
else if [OrderDate.2]<=31 and [OrderDate.2]<>[Month] then [OrderDate.2]
else if [OrderDate.3]<=31 and [OrderDate.3]<>[Month] then [OrderDate.3]
else 
[Month]),
    #"Changed Type4" = Table.TransformColumnTypes(#"Added Custom",{{"Custom", Int64.Type}}),
    #"Renamed Columns4" = Table.RenameColumns(#"Changed Type4",{{"Custom", "Day"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns4",{"OrderDate.1", "OrderDate.2", "OrderDate.3"}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Removed Columns2", {{"Month", type text}, {"Day", type text}, {"Year", type text}}, "en-US"),{"Month", "Day", "Year"},Combiner.CombineTextByDelimiter("-", QuoteStyle.None),"Date"),
    #"Changed Type5" = Table.TransformColumnTypes(#"Merged Columns",{{"Date", type date}})
in
    #"Changed Type5"
