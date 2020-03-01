Dependencies
~~~~~~~~~~~~~

 * Download and install the `Debugging Tools for Windows`_ from MSDN and create
   the environment variable ``WIN_DEBUGGING_TOOLS_PATH`` which points to the
   installation directory.

 * Download and install `Python 3`_ from the official site.
   Afterwards create an environment variable ``PYTHON3_PATH`` pointing to the
   installation directory.

 * Install PyKd_ via PIP as described at their site.
   In case the Python executable is not in your PATH environment variable an
   alternative is to go to the Python installation directory and execute
   `python.exe -m pip install pykd`

 * If you want to set up the automatic dump analysis, you also need 7-Zip_.
   Download and install it and create an environment variable ``7ZIP_PATH``
   which points to the corresponding installation folder.

 * Execute the powershell script install.ps1_.
   You may need administrator rights to execute this script.

.. _Debugging Tools for Windows: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger
.. _Python 3: https://www.python.org/downloads
.. _PyKd: https://githomelab.ru/pykd/pykd
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
