# mobilityDCAT-AP Validator

A free online validator that checks how well a data catalogue complies with [mobilityDCAT-AP](https://mobilitydcat-ap.github.io/mobilityDCAT-AP/), the metadata profile National Access Points (NAPs) use under the EU ITS Directive.

**Try it:** [mobility-dcat-validator.redpencil.io](https://mobility-dcat-validator.redpencil.io/)

## Background

This validator grew out of the analysis tooling built for our study *mobilityDCAT-AP in Practice: Compliance Analysis of European NAPs and the Belgian Reference Implementation*, presented at the ITS European Congress 2026 in Istanbul. The study's data, scripts and findings are at [redpencilio/mobilitydcatap-study](https://github.com/redpencilio/mobilitydcatap-study).

## What it does

You enter the URL of a catalogue endpoint, and the validator:

1. **Harvests** the catalogue, following pagination, and loads the RDF into a triplestore.
2. **Validates** it with SHACL against the mobilityDCAT-AP shapes.
3. **Analyses coverage** to show how many datasets, distributions, etc. fill in each mandatory, recommended and optional property.
4. **Checks controlled vocabularies** to flag values that are not part of the expected codelists (e.g. free text or local identifiers instead of URIs).

The results are shown as a report you can share, split by target class and rule. If a catalogue was validated recently, the cached report is reused.

## Architecture

This repository holds the [semantic.works](https://semantic.works) (mu.semte.ch) stack that ties the services together. Every step of a validation is a task in a job, managed by the job controller (`config/job-controller/config.json`):

| Service                                               | Role                                                                                                                                |
|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `frontend`                                            | [frontend-dcat-validator](https://github.com/redpencilio/frontend-dcat-validator), the Ember web app                                |
| `validation-api`                                      | Accepts new validation jobs (`POST /validation-jobs`)                                                                               |
| `catalog-harvester`                                   | Harvests the remote catalogue                                                                                                       |
| `dcat-validator`                                      | [dcat-validator-service](https://github.com/redpencilio/dcat-validator-service): SHACL validation, coverage and vocabulary analysis |
| `job-controller`                                      | Schedules the next task in the job when the previous one finishes                                                                   |
| `delta-notifier`                                      | Tells services about changes in the triplestore                                                                                     |
| `resource`                                            | JSON:API for jobs, tasks and reports (`config/resources`)                                                                           |
| `dispatcher`                                          | Routes requests (`config/dispatcher/dispatcher.ex`)                                                                                 |
| `identifier`, `database`, `triplestore`, `migrations` | Other, standard semantic.works infrastructure (sessions, authorization, Virtuoso, migrations)                                       |

The domain model is in `doc/model.ttl`.

## Running it locally

Requirements: Docker with Docker Compose.

```sh
git clone https://github.com/redpencilio/app-mobilitydcatap-validator.git
cd app-mobilitydcatap-validator
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

`docker-compose.dev.yml` exposes the app on port 80 and Virtuoso on port 8890, and runs the frontend and services in development mode. Then open [http://localhost](http://localhost).

To work on the frontend or a service, add a `docker-compose.override.yml` (it is git-ignored) that points the service at your local build.

## Contact

Questions or feedback about the validator: [info+mobilitydcatap@redpencil.io](mailto:info+mobilitydcatap@redpencil.io)

If you are a NAP owner, mobility data publisher, or ITS policy maker and want to discuss Mobility DCAT-AP compliance, data quality, or building tools on top of open mobility data, we'd love to hear from you:

**[redpencil.io/contact](https://redpencil.io/contact)**

## License

MIT, see [LICENSE](LICENSE). The project metadata is also in [`publiccode.yml`](publiccode.yml).
