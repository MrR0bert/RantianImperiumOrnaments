$xmlTemplate = @"
    <ModOps>
        <ModOp Type="add" Path="/TextExport/Texts">
            @@TEXTS@@
        </ModOp>
    </ModOps>
"@

$textBlock = @"
    <Text>
      <GUID>{0}</GUID>
      <Text>{1}</Text>
    </Text>
"@

$assetMap  = Import-Csv -Path 'asset-guid-map.csv' -Header GUID,Text -Delimiter ";"

$textBlocks = foreach( $asset in $assetMap ) {
    if( $asset.GUID -notmatch "([0-9]{1,})" ) {
        continue
    }

    $textBlock -f $asset.GUID,$asset.Text
}

$xmlTemplate -replace '@@TEXTS@@', ($textBlocks -join [environment]::NewLine) | Set-Content -Path "src/data/config/gui/texts_english.xml" -Encoding utf8 -Force