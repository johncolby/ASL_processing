from setuptools import setup

setup(
    name='ASL_processing',
    version='0.1.0',
    packages=["ASL_processing"],
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        "json_minify",
        "matplotlib",
        "nibabel",
        "numpy",
        "pandas",
        "scipy",
        "seaborn",
        "xlwt"
    ],
    entry_points={'console_scripts': ['process_data = ASL_processing.process_data:cli']},
    scripts=['bin/process_data_docker']
)
