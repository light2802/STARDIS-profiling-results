# Import necessary code

import numpy as np
import matplotlib.pyplot as plt

from tardis.io.atom_data.util import download_atom_data

from stardis.base import run_stardis

from astropy import units as u, constants as const

# Download atomic data if you are running this for the first time

#download_atom_data('kurucz_cd23_chianti_H_He')

tracing_lambdas = np.arange(5000, 7000, .01) * u.Angstrom

sim = run_stardis('profile.yml', tracing_lambdas)

plt.plot(sim.lambdas, sim.spectrum_lambda)

plt.xlim((4800, 7200))
plt.title("STARDIS Solar Spectrum")
plt.xlabel("Wavelength [$\AA$]")
plt.ylabel("Flux density [erg/s/cm$^2$/$\AA$]")

plt.savefig('foo.png')
