#! ../prog/BCI2000Shell
@cls & ..\prog\BCI2000Shell %0 %* #! && exit /b 0 || exit /b 1\n
#######################################################################################
## $Id: NuLab BCI by Emanuel Lorenz, 2019 $
## Description: BCI2000 startup Operator module script. For an Operator scripting
##   reference, see
##   http://doc.bci2000.org/index/User_Reference:Operator_Module_Scripting
##
## $BEGIN_BCI2000_LICENSE$
##
## This file is part of BCI2000, a platform for real-time bio-signal research.
## [ Copyright (C) 2000-2012: BCI2000 team and many external contributors ]
##
## BCI2000 is free software: you can redistribute it and/or modify it under the
## terms of the GNU General Public License as published by the Free Software
## Foundation, either version 3 of the License, or (at your option) any later
## version.
##
## BCI2000 is distributed in the hope that it will be useful, but
##                         WITHOUT ANY WARRANTY
## - without even the implied warranty of MERCHANTABILITY or FITNESS FOR
## A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along with
## this program.  If not, see <http://www.gnu.org/licenses/>.
##
## $END_BCI2000_LICENSE$ 
#######################################################################################
Change directory $BCI2000LAUNCHDIR
Echo Please enter a subject name:
Set SubjectName ${Read line}
Echo Please enter the date (YYMMDD):
Set SubjectSession ${Read line}
Echo Please enter the recording number:
Set SubjectRun ${Read line}
Show window; Set title ${Extract file base $0}
Reset system
ADD EVENT T 8 0 0 0
ADD EVENT R 8 0 0 0
INSERT STATE M 8 0 0 0
INSERT STATE E 8 0 0 0
Startup system localhost
Start executable AmpServerPro --local
Start executable DummyApplication --local
Start executable FieldTripBuffer --local
Wait for Connected
Load parameterfile "../parms/NU_BCI_Test_3.prm"
Set parameter SubjectName $SubjectName
Set parameter SubjectSession $SubjectSession 
Set parameter SubjectRun $SubjectRun
Set config
Wait for Resting
