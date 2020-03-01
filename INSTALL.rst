Dependencies
~~~~~~~~~~~~~

 * Download and install the `Debugging Tools for Windows`_ from MSDN and create
   the environment variable ``WIN_DEBUGGING_TOOLS_PATH`` which points to the
   installation directory.

 * Download and install PyKd_ from CodePlex. Afterwards create an environment
   variable ``PYTHON2_PATH`` pointing to the directory of python which was
   installed during the PyKd installation.

 * If you want to set up the automatic dump analysis, you also need 7-Zip_.
   Download and install it and create an environment variable ``7ZIP_PATH``
   which points to the corresponding installation folder.

 * Execute the powershell script install.ps1_.
   You may need administrator rights to execute this script.

.. _Debugging Tools for Windows: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger
.. _PyKd: http://pykd.codeplex.com/
.. _7-Zip: http://www.7-zip.org/
.. _install.ps1: install.ps1


Automatic Dump Analysis
~~~~~~~~~~~~~~~~~~~~~~~~

Execute the powershell script set_up_auto_analysis.ps1_ with administrator
rights. This will create a scheduled task which runs every minute, checks for
new dumps, analyses and moves them to a specific directory along with the log
of the analysis. Before the dumps are moved, they are compressed via 7-Zip.

The configuration file, which specifies the directories to observe and where to
move the compressed dumps to, is located under
``%APPDATA%\AOSCrashDumpAnalysis``.
This directory also contains the log of the scheduled task in case logging is
enabled in the configuration file.

.. _set_up_auto_analysis.ps1: set_up_auto_analysis.ps1
