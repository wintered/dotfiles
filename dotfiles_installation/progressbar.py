import logging
try:
    from tqdm import tqdm
except ImportError:
    logging.warn(
        "Python package 'tqdm' is not installed.\n"
        "If you would like to see a progressbar, cancel installation with "
        "(Ctrl+C) and do 'pip3 install tqdm' first."
    )
    TQDM_INSTALLED = False
else:
    TQDM_INSTALLED = True


def progress(installables, total, dryrun):
    if not dryrun and TQDM_INSTALLED:
        return tqdm(installables, total=total)
    else:
        return installables
