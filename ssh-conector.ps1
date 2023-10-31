Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 接続先情報の連想配列リスト
$connectionInformationList = @(
    @{
        product = "productA";
        env     = "dev";
        host    = "hostA";
        ip      = "000.000.000.000"
    },
    @{
        product = "productA";
        env     = "prod";
        host    = "hostB";
        ip      = "000.000.000.001"
    },
    @{
        product = "productB";
        env     = "prod";
        host    = "hostC";
        ip      = "000.000.000.000"
    }
)

# menu コマンドの表示用変数
$MenuPreference = @{
    ForegroundColor          = "Gray"
    BackgroundColor          = "Black"
    SelectionForegroundColor = "DarkGray"
    SelectionBackgroundColor = "White"
}

# ユニークなプロダクトのリストを返却する関数
function ExtractUniqueProduct ($connectionInformationList) {
    $productList = @()

    foreach ( $connectionInformation in $connectionInformationList ) {
        $productList += $connectionInformation.product
    }

    return $productList | Sort-Object | Get-Unique
}

# 特定のプロダクトの接続先情報だけを抜き出す関数
function ExtractConnectionInformations {

    Param(
        $connectionInformationList,
        $product
    )

    $connectionInformations = @()

    foreach ( $connectionInformation in $connectionInformationList ) {
        if ($connectionInformation.product -eq $product) {
            $connectionInformations += $connectionInformation
        }
    }

    return $connectionInformations
}

# 「接続先(ip)」に整形する関数
function FormattingConnectionInformations ($connectionInformationList) {
    $connectionInformations = @()

    foreach ( $connectionInformation in $connectionInformationList ) {
        $connectionInformations += $connectionInformation.host + "`t" + $connectionInformation.ip
    }

    return $connectionInformations
}

# ここからmain処理
# ----------------------------------------------------

$uniqProductList = ExtractUniqueProduct $connectionInformationList
$product = menu $uniqProductList

$connectionInformations += ExtractConnectionInformations -connectionInformationList $connectionInformationList -product $product
$connectList = FormattingConnectionInformations $connectionInformations
$connectInfo = menu $connectList
$ip = $connectInfo.split("`t")[1]
$ip

# 接続するコマンドを書く