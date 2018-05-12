from tqdm import tqdm


def progress(installables, total, dryrun):
    if dryrun:
        return installables
    else:
        return tqdm(installables, total=total)
