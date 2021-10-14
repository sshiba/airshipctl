.. _airshipctl_phase_run:

airshipctl phase run
--------------------

Airshipctl command to run phase

Synopsis
~~~~~~~~


Run a phase such as controlplane-ephemeral, remotedirect-ephemeral, initinfra-ephemeral, etc...
To list the phases associated with a site, run 'airshipctl phase list'.


::

  airshipctl phase run PHASE_NAME [flags]

Examples
~~~~~~~~

::


  Run initinfra phase
  # airshipctl phase run ephemeral-control-plane


Options
~~~~~~~

::

      --dry-run                 simulate phase execution
  -h, --help                    help for run
      --wait-timeout duration   wait timeout

Options inherited from parent commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

      --airshipconf string   path to the airshipctl configuration file. Defaults to "$HOME/.airship/config"
      --debug                enable verbose output

SEE ALSO
~~~~~~~~

* :ref:`airshipctl phase <airshipctl_phase>` 	 - Airshipctl command to manage phases

