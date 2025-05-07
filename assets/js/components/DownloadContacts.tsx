export function DownloadContacts() {
  return (
    <div className="flex flex-col gap-2.5">
      <div>
        <h2>Download contacts</h2>
        <p>Export your contacts in CSV.</p>
      </div>

      <div>
        <a href="/contacts/export" className="btn" download>
          Export
        </a>
      </div>
    </div>
  )
}
