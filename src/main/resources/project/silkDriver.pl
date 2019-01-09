use warnings;
use strict; 
$|=1;

use ElectricCommander;
# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
	EMPTY_VALUE => '',
	CHECKED => 1,
	NOT_CHECKED => 0
};

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------

$::gSilkFile = "$[silkFile]";
$::gTargetMachine = "$[targetMachine]";
$::gProj = q{$[proj]};
$::gBase = q{$[base]};
$::gQuery = "$[query]";
$::gWDirectory = q{$[wDirectory]};
$::gDirectory = q{$[directory]};
$::gCompLog = q{$[compLog]};
$::gAdditionalOptions = "$[additionalOptions]";
$::gResFile ="$[resFile]";
$::gChkArguments ="$[chkArguments]";
$::gtestArguments = "$[testArguments]";
$::gResFile ="$[resFile]";

########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
    
    # create args array
    my @args = ();
    
    #properties' map
    my %props;
    
    #executable to use
    my $executable ='partner';
    
    #insert program to invoke
    push(@args, $executable);

    #Specifies the target machine.
    if($::gTargetMachine  && $::gTargetMachine ne EMPTY_VALUE) {
        push(@args,  '-m '.$::gTargetMachine);
    }
    #Specifies the project file.
    if($::gProj && $::gProj ne EMPTY_VALUE) {
        push(@args, '-proj '.$::gProj);
    }
    #Specify the location where you want to unpack the package contents
    if($::gBase && $::gBase ne EMPTY_VALUE) {
        push(@args, '-base '.$::gBase);
    }
    #Tells SilkTest to log compilation errors to a file you specify

    if($::gCompLog  && $::gCompLog  ne EMPTY_VALUE) {
        push(@args,'-complog '.$::gCompLog);
    }
    # Specifies a query. Must be followed by the name of a saved query

    if($::gQuery  && $::gQuery  ne EMPTY_VALUE) {
        push(@args, '-query '.$::gQuery);
    }
    #Activate or desactivate the result rex files

    if($::gResFile eq CHECKED) {
        push(@args, '-resexport');
    }
    elsif($::gResFile eq NOT_CHECKED) {
        push(@args, '');
    }
    #Additional options can be added to the silk command

    if($::gAdditionalOptions  && $::gAdditionalOptions  ne EMPTY_VALUE) {
        foreach my $command (split(' ',$::gAdditionalOptions)) {
            push(@args, $command);
        }
    }
    #The silk file can be a test, suite, test plan, or link file

    if($::gSilkFile  && $::gSilkFile ne EMPTY_VALUE) {
        push(@args, '-r '.$::gSilkFile);
    }
    #Arguments for a test file, they are optional

    if($::gtestArguments &&  $::gtestArguments ne EMPTY_VALUE&& $::gChkArguments eq CHECKED  ) {
        push(@args, $::gtestArguments);
    }
    #Directory on wich the silk file is located
    
    if($::gDirectory  && $::gDirectory ne EMPTY_VALUE && $::gSilkFile ne EMPTY_VALUE) {
        push(@args, $::gDirectory);
    }
    #Generate the command to execute in console

    $props{'workingDir'} = $::gWDirectory;
    $props{'commandLine'} = createCommandLine(\@args);
    

    setProperties(\%props);
}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

    my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    return $command;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

main();
