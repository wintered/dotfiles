try:
    from tqdm import tqdm
except ImportError:
    TQDM_INSTALLED = False
else:
    TQDM_INSTALLED = True


def progress(installables, total, dryrun):
    if not dryrun and TQDM_INSTALLED:
        return tqdm(installables, total=total)
    else:
        return installables
