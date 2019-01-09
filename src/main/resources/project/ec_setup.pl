my %runSilk = (
    label       => "SilkTest - Run SilkTest",
    procedure   => "runSilk",
    description => "Runs SilkTest",
    category    => "Test"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/SilkTest - Run SilkTest");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/SilkTest - runSilkTest");

@::createStepPickerSteps = (\%runSilk);