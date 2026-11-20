// Power Query (M) - Customers query
// Copied from Advanced Editor. Source paths are local; point them to your own data folder.
let
    Source = Csv.Document(File.Contents("D:\Data Analysis\Material P2\PowerQuery\Customers.csv"),[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"CustomerID", Int64.Type}, {"CustomerName", type text}, {"Region", type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Changed Type",{{"CustomerName", Text.Proper, type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Capitalized Each Word",{{"CustomerName", Text.Trim, type text}, {"Region", Text.Trim, type text}}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Trimmed Text",{{"Region", Text.Proper, type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Capitalized Each Word1", each true),
    #"Replaced Value" = Table.ReplaceValue(#"Filtered Rows"," ","",Replacer.ReplaceText,{"Region"}),
    #"Filtered Rows1" = Table.SelectRows(#"Replaced Value", each true),
    #"Capitalized Each Word2" = Table.TransformColumns(#"Filtered Rows1",{{"Region", Text.Proper, type text}}),
    #"Filtered Rows2" = Table.SelectRows(#"Capitalized Each Word2", each true),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filtered Rows2", "CustomerName", Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv), {"CustomerName.1", "CustomerName.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"CustomerName.1", type text}, {"CustomerName.2", type text}}),
    #"Capitalized Each Word3" = Table.TransformColumns(#"Changed Type1",{{"CustomerName.2", Text.Proper, type text}, {"CustomerName.1", Text.Proper, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Capitalized Each Word3",{{"CustomerName.1", Text.Trim, type text}, {"CustomerName.2", Text.Trim, type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Trimmed Text1",{{"CustomerName.1", "First Name"}, {"CustomerName.2", "Second Name"}})
in
    #"Renamed Columns"
