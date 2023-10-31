Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# �ڑ�����̘A�z�z�񃊃X�g
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

# menu �R�}���h�̕\���p�ϐ�
$MenuPreference = @{
    ForegroundColor          = "Gray"
    BackgroundColor          = "Black"
    SelectionForegroundColor = "DarkGray"
    SelectionBackgroundColor = "White"
}

# ���j�[�N�ȃv���_�N�g�̃��X�g��ԋp����֐�
function ExtractUniqueProduct ($connectionInformationList) {
    $productList = @()

    foreach ( $connectionInformation in $connectionInformationList ) {
        $productList += $connectionInformation.product
    }

    return $productList | Sort-Object | Get-Unique
}

# ����̃v���_�N�g�̐ڑ����񂾂��𔲂��o���֐�
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

# �u�ڑ���(ip)�v�ɐ��`����֐�
function FormattingConnectionInformations ($connectionInformationList) {
    $connectionInformations = @()

    foreach ( $connectionInformation in $connectionInformationList ) {
        $connectionInformations += $connectionInformation.host + "`t" + $connectionInformation.ip
    }

    return $connectionInformations
}

# ��������main����
# ----------------------------------------------------

$uniqProductList = ExtractUniqueProduct $connectionInformationList
$product = menu $uniqProductList

$connectionInformations += ExtractConnectionInformations -connectionInformationList $connectionInformationList -product $product
$connectList = FormattingConnectionInformations $connectionInformations
$connectInfo = menu $connectList
$ip = $connectInfo.split("`t")[1]
$ip

# �ڑ�����R�}���h������