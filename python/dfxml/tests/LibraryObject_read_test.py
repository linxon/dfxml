
# This software was developed at the National Institute of Standards
# and Technology by employees of the Federal Government in the course
# of their official duties. Pursuant to title 17 Section 105 of the
# United States Code this software is not subject to copyright
# protection and is in the public domain. NIST assumes no
# responsibility whatsoever for its use by other parties, and makes
# no guarantees, expressed or implied, about its quality,
# reliability, or any other characteristic.
#
# We would appreciate acknowledgement if the software is used.

"""
Run test against DFXML file generatd by the _write counterpart script.
"""

__version__="0.1.0"

import sys
import logging
import os

sys.path.append( os.path.join(os.path.dirname(__file__), "../.."))

import dfxml
import dfxml.objects as Objects

if __name__=="__main__":

    logging.basicConfig(level=logging.DEBUG)
    _logger = logging.getLogger(os.path.basename(__file__))

    dobj = Objects.parse(sys.argv[1])

    _logger.debug("dobj.creator_libraries = %r." % dobj.creator_libraries)

    assert Objects.LibraryObject("libfoo", "1.2.3") in dobj.creator_libraries
    assert Objects.LibraryObject("libbaz", "4.5") in dobj.build_libraries

    found = None
    for library in dobj.creator_libraries:
        if library.relaxed_eq(Objects.LibraryObject("libfoo")):
            found = True
            break
    assert found