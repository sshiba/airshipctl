/*
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package phase

import (
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"

	"opendev.org/airship/airshipctl/pkg/config"
	"opendev.org/airship/airshipctl/pkg/phase"
)

const (
	// TODO (kkalynovskyi) when different phase executors will be implemented, and their description is more clear,
	// add documentation here. also consider adding dynamic phase descriptions based on executors.
	runLong = `
Run a phase such as controlplane-ephemeral, remotedirect-ephemeral, initinfra-ephemeral, etc...
To list the phases associated with a site, run 'airshipctl phase list'.
`
	runExample = `
Run initinfra phase
# airshipctl phase run ephemeral-control-plane
`
)

// NewRunCommand creates a command to run specific phase
func NewRunCommand(cfgFactory config.Factory) *cobra.Command {
	p := &phase.RunCommand{Factory: cfgFactory}
	f := &phase.RunFlags{}

	runCmd := &cobra.Command{
		Use:     "run PHASE_NAME",
		Short:   "Airshipctl command to run phase",
		Long:    runLong[1:],
		Args:    cobra.ExactArgs(1),
		Example: runExample,
		RunE: func(cmd *cobra.Command, args []string) error {
			p.PhaseID.Name = args[0]
			// Go through all the flags that have been set
			fn := func(flag *pflag.Flag) {
				switch flag.Name {
				case "dry-run":
					p.Options.DryRun = f.DryRun
				case "wait-timeout":
					p.Options.Timeout = &f.Timeout
				}
			}
			cmd.Flags().Visit(fn)
			return p.RunE()
		},
	}
	flags := runCmd.Flags()
	flags.BoolVar(&f.DryRun, "dry-run", false, "simulate phase execution")
	flags.DurationVar(&f.Timeout, "wait-timeout", 0, "wait timeout")
	return runCmd
}
