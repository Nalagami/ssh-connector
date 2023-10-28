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

# window
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = 'CenterScreen'

# OK�{�^��
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75, 120)
$okButton.Size = New-Object System.Drawing.Size(75, 23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# Cancal�{�^��
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150, 120)
$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# �I�����g
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Please select a computer:'
$form.Controls.Add($label)

# �I����
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10, 40)
$listBox.Size = New-Object System.Drawing.Size(260, 20)
$listBox.Height = 80
$uniqProductList = ExtractUniqueProduct $connectionInformationList
foreach ($Product in $uniqProductList) {
    [void] $listBox.Items.Add($Product)
}
$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if (($result -ne [System.Windows.Forms.DialogResult]::OK) -or ($null -eq $listBox.SelectedItem)) {
    Write-Host '��O���������܂���'
    exit
}

$connectionInformations = @()

$product = $listBox.SelectedItem
$connectionInformations += ExtractConnectionInformations -connectionInformationList $connectionInformationList -product $product

$form.Controls.Remove($listBox)

# �I�����ēx�쐬
$connectListBox = New-Object System.Windows.Forms.ListBox
$connectListBox.Location = New-Object System.Drawing.Point(10, 40)
$connectListBox.Size = New-Object System.Drawing.Size(260, 20)
$connectListBox.Height = 80
$connectList = FormattingConnectionInformations $connectionInformations
foreach ($connect in $connectList) {
    [void] $connectListBox.Items.Add($connect)
}
$form.Controls.Add($connectListBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $connectInfo = $connectListBox.SelectedItem
    $ip = $connectInfo.split("`t")
    $ip

    # �ڑ�����R�}���h������
    # ssh $connectInfo
}