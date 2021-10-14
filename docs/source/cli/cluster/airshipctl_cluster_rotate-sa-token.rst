.. _airshipctl_cluster_rotate-sa-token:

airshipctl cluster rotate-sa-token
----------------------------------

Airshipctl command to rotate tokens of Service Account(s)

Synopsis
~~~~~~~~


Reset/rotate the Service Account(SA) tokens and additionally restart the corresponding pods to get the latest
token data reflected in the pod spec.

Secret-namespace is a mandatory flag and secret-name is optional. If a secret-name is not specified, all of the SA
tokens in the specified namespace are rotated, else only the specified secret-name.


::

  airshipctl cluster rotate-sa-token [flags]

Examples
~~~~~~~~

::


  To rotate a particular SA token
  # airshipctl cluster rotate-sa-token -n cert-manager -s cert-manager-token-vvn9p

  To rotate all the SA tokens in cert-manager namespace
  # airshipctl cluster rotate-sa-token -n cert-manager


Options
~~~~~~~

::

  -h, --help                      help for rotate-sa-token
      --kubeconfig string         path to kubeconfig associated with cluster being managed
  -s, --secret-name string        name of the secret containing Service Account Token
  -n, --secret-namespace string   namespace of the Service Account Token

Options inherited from parent commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

      --airshipconf string   path to the airshipctl configuration file. Defaults to "$HOME/.airship/config"
      --debug                enable verbose output

SEE ALSO
~~~~~~~~

* :ref:`airshipctl cluster <airshipctl_cluster>` 	 - Airshipctl command to manage kubernetes clusters

