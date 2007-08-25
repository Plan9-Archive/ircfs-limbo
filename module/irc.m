Irc: module {
	PATH:	con "/dis/lib/irc.dis";

	init:	fn(b: Bufio);

	RPLwelcome:	con 1;
	RPLaway:	con 301;
	RPLtopic:	con 332;
	RPLtopicset:	con 333;
	RPLinviting:	con 341;
	RPLnames:	con 353;
	RPLnamesdone:	con 366;
	RPLnickinuse:	con 433;

	Maximsglen:	con 512;

	ischannel:	fn(name: string): int;
	lowercase:	fn(name: string): string;

	Ircc: adt {
		fd:	ref Sys->FD;
		b:	ref Iobuf;
		addr:	string;
		nick, lnick:	string;

		new:	fn(fd: ref Sys->FD, addr: string, nick, name: string): (ref Ircc, string);
		readmsg:	fn(c: self ref Ircc): (ref Rimsg, string, string);
		writemsg:	fn(c: self ref Ircc, m: ref Timsg): string;
		fromself:	fn(c: self ref Ircc, f: ref From): int;
	};

	From: adt {
		nick, server, user, host: string;

		text:	fn(f: self ref From): string;
	};

	Timsg: adt {
		pick {
		Nick or User or Names =>
			name: string;
		Privmsg or Notice =>
			who, m: string;
		Join =>
			where: string;
		Away =>
			m: string;
		Part =>
			where: string;
		Topicget =>
			where: string;
		Topicset =>
			where, m: string;
		Quit =>
			m: string;
		Pong =>
			who, m: string;
		Mode =>
			where, mode, params: string;
		Kick =>
			where, who, m: string;
		Whois =>
			name: string;
		Invite =>
			who, where: string;
		}

		pack:	fn(m: self ref Timsg): string;
		text:		fn(m: self ref Timsg): string;
	};

	Rimsg: adt {
		f: ref From;
		cmd:	string;
		pick {
		Nick =>
			name: string;
		Mode =>
			who, mode, modeparams: string;
		Quit or Error or Squit =>
			m: string;
		Join =>
			where: string;
		Part or Topic or Privmsg or Notice =>
			where, m: string;
		Ping =>
			who, m: string;
		Pong =>
			who, m: string;
		Kick =>
			where, who, m: string;
		Unknown or Replytext or Errortext =>
			where: string;	# may be empty
			params: array of string;
		}

		unpack:	fn(s: string): (ref Rimsg, string);
		text:	fn(m: self ref Rimsg): string;
	};
};
