Add-Type -AssemblyName System.Windows.Forms

$powerSchemes = powercfg /l | ForEach-Object {
    if ($_ -match '^Power Scheme GUID:\s*([-0-9a-f]+)\s*\(([^)]+)\)\s*(\*)?') {
        [PsCustomObject]@{
            GUID       = $matches[1]
            SchemeName = $matches[2]
            Active     = $matches[3] -eq '*'
        }
    }
}
$PP1 = $powerSchemes | Where-Object { $_.SchemeName -eq 'Balanced' }
$PP2 = $powerSchemes | Where-Object { $_.SchemeName -eq 'Power Saving' }

if ($PP1.Active) {
    powercfg /s $($PP2.GUID)
    $activePlan = "Power Saving"
} else {
    powercfg /s $($PP1.GUID)
    $activePlan = "Balanced"
}

$form = New-Object System.Windows.Forms.Form
$form.Text = ""
$form.ControlBox = $false
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.BackColor = "#3D3D3D" # Change the background color here
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.Opacity = 0.9
$form.Width = 350 # Change the width of the box here
$form.Height = 100 # Change the height of the box here

$label = New-Object System.Windows.Forms.Label
$label.AutoSize = $false
$label.Width = $form.Width
$label.Height = $form.Height
$label.Text = $activePlan
$label.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold) # Change the font and size here
$label.ForeColor = "Gray" # Change the text color here
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$label.Left = ($form.Width - $label.Width) / 2
$label.Top = ($form.Height - $label.Height) / 2

$form.Controls.Add($label)

$form.Show()

for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Milliseconds 100
    if ($i -gt 10) {
        $form.Opacity -= 0.05
    }
}

$form.Close()
