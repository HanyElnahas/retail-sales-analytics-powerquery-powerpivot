// Power Query (M) - Products query
// Copied from Advanced Editor. Source paths are local; point them to your own data folder.
let
    Source = Csv.Document(File.Contents("D:\Data Analysis\Material P2\PowerQuery\Products.csv"),[Delimiter=",", Columns=4, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ProductID", Int64.Type}, {"ProductName", type text}, {"Category", type text}, {"Price", type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Changed Type",{{"ProductName", Text.Proper, type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Capitalized Each Word",{{"ProductName", Text.Trim, type text}}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Trimmed Text",{{"Category", Text.Proper, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Capitalized Each Word1",{{"Category", Text.Trim, type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Trimmed Text1", each true),
    #"Replaced Value" = Table.ReplaceValue(#"Filtered Rows","Two Hundred","200",Replacer.ReplaceText,{"Price"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Replaced Value",{{"Price", Currency.Type}})
in
    #"Changed Type1"
