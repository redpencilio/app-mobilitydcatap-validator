export default [
  {
    match: {
      subject: {},
    },
    callback: {
      url: "http://resource/.mu/delta",
      method: "POST",
    },
    options: {
      resourceFormat: "v0.0.1",
      gracePeriod: 1000,
      foldEffectiveChanges: true,
      ignoreFromSelf: true,
    },
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      }
    },
    callback: {
      method: 'POST',
      url: 'http://job-controller/delta'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      sendMatchesOnly: true
    }
  },
  {
    match: {
      predicate: {
        type: "uri",
        value: "http://www.w3.org/ns/adms#status",
      },
      object: {
        type: "uri",
        value: "http://redpencil.data.gift/id/concept/JobStatus/scheduled",
      },
    },
    callback: {
      url: "http://dcat-validator/jobs-delta",
      method: "POST",
    },
    options: {
      resourceFormat: "v0.0.1",
      gracePeriod: 1000,
      ignoreFromSelf: true,
      sendMatchesOnly: true
    },
  },
  {
    match: {
      predicate: {
        type: "uri",
        value: "http://www.w3.org/ns/adms#status",
      },
      object: {
        type: "uri",
        value: "http://redpencil.data.gift/id/concept/JobStatus/scheduled",
      },
    },
    callback: {
      url: "http://catalog-harvester/jobs-delta",
      method: "POST",
    },
    options: {
      resourceFormat: "v0.0.1",
      gracePeriod: 1000,
      ignoreFromSelf: true,
      sendMatchesOnly: true
    },
  }
];
