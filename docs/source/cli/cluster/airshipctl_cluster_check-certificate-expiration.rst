.. _airshipctl_cluster_check-certificate-expiration:

airshipctl cluster check-certificate-expiration
-----------------------------------------------

Airshipctl command to check expiring TLS certificates, secrets and kubeconfigs in the kubernetes cluster

Synopsis
~~~~~~~~


Displays a list of certificate along with expirations from both the management and workload clusters, or in a
self-managed cluster. Checks for TLS Secrets, kubeconf secrets (which gets created while creating the
workload cluster) and also the node certificates present inside /etc/kubernetes/pki directory for each node.


::

  airshipctl cluster check-certificate-expiration [flags]

Examples
~~~~~~~~

::


  To display all the expiring certificates in the cluster
  # airshipctl cluster check-certificate-expiration --kubeconfig testconfig

  To display the certificates whose expiration is within threshold of 30 days
  # airshipctl cluster check-certificate-expiration -t 30 --kubeconfig testconfig

  To output the contents in json format (default operation)
  # airshipctl cluster check-certificate-expiration -o json --kubeconfig testconfig
  or
  # airshipctl cluster check-certificate-expiration --kubeconfig testconfig

  To output the contents in yaml format
  # airshipctl cluster check-certificate-expiration -o yaml --kubeconfig testconfig

  To output the contents whose expiration is within 30 days in yaml format
  # airshipctl cluster check-certificate-expiration -t 30 -o yaml --kubeconfig testconfig


Options
~~~~~~~

::

  -h, --help                 help for check-certificate-expiration
      --kubeconfig string    path to kubeconfig associated with cluster being managed
      --kubecontext string   kubeconfig context to be used
  -o, --output string        convert output to yaml or json (default "json")
  -t, --threshold int        the max expiration threshold in days before a certificate is expiring. Displays all the certificates by default (default -1)

Options inherited from parent commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

      --airshipconf string   path to the airshipctl configuration file. Defaults to "$HOME/.airship/config"
      --debug                enable verbose output

SEE ALSO
~~~~~~~~

* :ref:`airshipctl cluster <airshipctl_cluster>` 	 - Airshipctl command to manage kubernetes clusters

